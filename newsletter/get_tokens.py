from google_auth_oauthlib.flow import InstalledAppFlow

# Scopes required to send email
SCOPES = ["https://www.googleapis.com/auth/gmail.send"]


def main():
    flow = InstalledAppFlow.from_client_secrets_file("credentials.json", SCOPES)
    creds = flow.run_local_server(port=0)

    # Save the credentials for later use
    with open("token.json", "w") as token_file:
        token_file.write(creds.to_json())


if __name__ == "__main__":
    main()
