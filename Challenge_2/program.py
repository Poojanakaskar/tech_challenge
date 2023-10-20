import requests  
import json  
  
def get_instance_metadata(key=None):  
    base_url = "http://169.254.169.254/latest/"  
  
    # First, we need to create a session token  
    session_url = base_url + "api/token"  
    headers = {"X-aws-ec2-metadata-token-ttl-seconds": "21600"} # Token will be valid for 6 hours  
    response = requests.put(session_url, headers=headers)  
    token = response.text  
  
    # Now we use this token to get the metadata  
    headers = {"X-aws-ec2-metadata-token": token}  
    meta_url = base_url + "meta-data/"  
      
    if key:  
        response = requests.get(meta_url + key, headers=headers)  
        return {key: response.text}  
  
    response = requests.get(meta_url, headers=headers)  
    meta_data_keys = response.text.split('\n')  
  
    metadata = {}  
    for key in meta_data_keys:  
        if key.endswith('/'):  
            continue  
        response = requests.get(meta_url + key, headers=headers)  
        metadata[key] = response.text  
  
    return json.dumps(metadata, indent=4)  
  
# To get all the metadata
print(get_instance_metadata())

# Replace 'ami-id' with the key you are interested in  
print(get_instance_metadata('ami-id'))  