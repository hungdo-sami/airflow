from google.oauth2 import service_account
from googleapiclient.discovery import build

def find_folder_id_by_name(service, folder_name, parent_folder_id=None):
    """
    Tìm ID của thư mục theo tên trong Google Drive.
    """
    query = f"mimeType='application/vnd.google-apps.folder' and name='{folder_name}'"
    if parent_folder_id:
        query += f" and '{parent_folder_id}' in parents"
        
    results = service.files().list(
        q=query,
        fields="files(id, name)",
        spaces='drive'
    ).execute()
    
    items = results.get('files', [])
    
    if not items:
        raise FileNotFoundError(f"No folder found with name '{folder_name}'")
    
    # Return the ID of the first folder found
    return items[0]['id']

# Ví dụ sử dụng
def main():
    credentials_json = '/home/hungdv/airflow/dags/meey-value-408909-e2d96bf085e1.json'
    credentials = service_account.Credentials.from_service_account_file(credentials_json)
    service = build('drive', 'v3', credentials=credentials)
    
    parent_folder_id = '1Ki8zdUC1veON4xIOHIs1ezgOyd-kT2g7'  # Thay thế bằng ID thư mục cha của bạn
    folder_name = 'meeyvalue'
    
    folder_id = find_folder_id_by_name(service, folder_name, parent_folder_id)
    print(f"ID của thư mục '{folder_name}' trong thư mục cha là: {folder_id}")

if __name__ == "__main__":
    main()
