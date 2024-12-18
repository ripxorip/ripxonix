#!/usr/bin/env python
import sys
import subprocess
import re
import os
from PyQt5.QtWidgets import (
    QApplication, QWidget, QVBoxLayout, QComboBox, QPushButton, QLabel, QMessageBox
)

class USBIPManager(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("USBIP Manager")
        self.setGeometry(200, 200, 400, 200)

        # Layout
        self.layout = QVBoxLayout()

        # Dropdown (ComboBox)
        self.device_dropdown = QComboBox(self)
        self.refresh_device_list()
        self.layout.addWidget(QLabel("Select USB Device:"))
        self.layout.addWidget(self.device_dropdown)

        # Buttons
        self.bind_button = QPushButton("Bind")
        self.bind_button.clicked.connect(self.bind_device)
        self.unbind_button = QPushButton("Unbind")
        self.unbind_button.clicked.connect(self.unbind_device)
        self.layout.addWidget(self.bind_button)
        self.layout.addWidget(self.unbind_button)

        # Set layout
        self.setLayout(self.layout)

        self.devices = []

    def refresh_device_list(self):
        """Populate the dropdown with the output of `usbip list -l`."""
        try:
            result = subprocess.run(["usbip", "list", "-l"], stdout=subprocess.PIPE, text=True, check=True)
            devices = self.parse_usbip_list(result.stdout)
            self.device_dropdown.clear()
            if devices:
                self.device_dropdown.addItems(devices)
            else:
                self.device_dropdown.addItem("No devices found")
        except subprocess.CalledProcessError as e:
            QMessageBox.critical(self, "Error", f"Failed to list USB devices: {e}")
            self.device_dropdown.addItem("Error listing devices")

    @staticmethod
    def parse_usbip_list(output):
        """Parse the output of `usbip list -l` to extract user-friendly device names."""
        devices = []
        current_device = None

        for line in output.splitlines():
            if line.startswith(" - busid"):  # Start of a new device
                current_device = line.split()[2]  # Extract the busid (e.g., 3-10)
            elif current_device and line.strip():  # The second line (user-friendly name)
                friendly_name = line.strip()  # Extract the user-friendly name
                full_name = f"{friendly_name} ({current_device})"
                devices.append(full_name)  # Combine name and busid
                current_device = None  # Reset for next device
        return devices


    def parse_device_info(self, device_string):
        """
        Parse vendor_id, product_id, and bus-id from a device string.
        Args:
            device_string (str): A string in the format:
                'Vendor Name : Product Name (vendor_id:product_id) (bus-id)'
        Returns:
            dict: A dictionary with keys 'vendor_id', 'product_id', and 'bus_id'.
        """
        # Regular expression to match the required fields
        match = re.search(r"\(([\da-fA-F]+):([\da-fA-F]+)\)\s+\(([\d\.\-]+)\)", device_string)
        if match:
            return {
                "vendor_id": match.group(1),
                "product_id": match.group(2),
                "bus_id": match.group(3)
            }
        else:
            raise ValueError(f"Invalid device string format: {device_string}")

    def get_selected_device(self):
        """Get the currently selected device."""
        return self.device_dropdown.currentText()

    def write_virsh_xml(self, device_info):
        with open("/tmp/usbip.xml", "w") as f:
            vendor_id = device_info["vendor_id"]
            product_id = device_info["product_id"]
            f.write(f"""
            <hostdev mode='subsystem' type='usb' managed='yes'>
                <source>
                    <vendor id='0x{vendor_id}'/>
                    <product id='0x{product_id}'/>
                </source>
            </hostdev>""")
        # Copy the XML file to the ripxostation /tmp/ folder
        os.system("scp /tmp/usbip.xml ripxorip@ripxostation:/tmp/usbip.xml")

    def get_the_running_vm(self):
        result = subprocess.run(["ssh", "ripxorip@ripxostation", "sudo", "virsh", "list", "--all"], stdout=subprocess.PIPE, text=True, check=True)
        res = result.stdout.splitlines()
        for l in res:
            l = l.split()
            if len(l) > 2 and l[2] == "running":
                return l[1]
        print("No running VMs found!")
        return ""

    def perform_bind(self, hostname, device_info):
        print("Binding device..")
        os.system(f"sudo usbip bind --busid={device_info['bus_id']}")
        os.system(f"ssh ripxorip@ripxostation sudo usbip attach -r {hostname} --busid={device_info['bus_id']}")
        self.write_virsh_xml(device_info)
        vm = self.get_the_running_vm()
        os.system(f"ssh ripxorip@ripxostation sudo virsh attach-device {vm} /tmp/usbip.xml --current")

    def perform_unbind(self, hostname, device_info):
        print("Unbinding device..")
        self.write_virsh_xml(device_info)
        vm = self.get_the_running_vm()
        os.system(f"ssh ripxorip@ripxostation sudo virsh detach-device {vm} /tmp/usbip.xml --current")
        os.system(f"sudo usbip unbind --busid={device_info['bus_id']}")

    def bind_device(self):
        """Bind the selected device."""
        device = self.get_selected_device()
        if device and "No devices found" not in device:
            device_info = self.parse_device_info(device)
            hostname = os.uname().nodename
            self.perform_bind(hostname, device_info)
        else:
            QMessageBox.warning(self, "Warning", "No valid device selected to bind")

    def unbind_device(self):
        """Unbind the selected device."""
        device = self.get_selected_device()
        if device and "No devices found" not in device:
            print(f"Unbinding device: {device}")
            device_info = self.parse_device_info(device)
            hostname = os.uname().nodename
            self.perform_unbind(hostname, device_info)
        else:
            QMessageBox.warning(self, "Warning", "No valid device selected to unbind")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = USBIPManager()
    window.show()
    sys.exit(app.exec_())
