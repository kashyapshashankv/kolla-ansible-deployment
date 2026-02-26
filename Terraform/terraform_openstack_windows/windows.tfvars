server_name = "test-server-win"
flavor_name = "Large"
image_name = "Windows_Server_2025"
boot_disk_size = 50
network_names = ["general-network"]
additional_volumes = [{
    "name": "data"
    "size": 15
  }]
ansible_playbook = "playbook_windows.yml"
os_user = "Administrator" #do not update this
os_password = "P@ssW0rD" #do not update this
user_data_file = "user_data_windows.yml"  #do not update this
