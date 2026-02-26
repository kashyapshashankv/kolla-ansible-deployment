server_name = "test-server"
flavor_name = "Large"
image_name = "Rocky9"
boot_disk_size = 50
network_names = ["general-network"]
additional_volumes = [{
    "name": "data"
    "size": 15
  }]
ansible_playbook = "playbook_linux.yml"
os_user = "tcsadmin" #Injected via userdata
os_password = "P@ssW0rD"
user_data_file = "user_data_linux.yml"  #do not update this
