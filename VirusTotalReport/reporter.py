import requests
import os
import requests
import smtplib
import ppretty
import argparse #I understand the limited imports and their purpose and this is not straying from that purpose.


def uploadFile(key, identifier):
    params = {'apikey': key}
	files = {'file': (identifier, open(identifier, 'rb'))}
	response = requests.post('https://www.virustotal.com/vtapi/v2/file/scan', files=files, params=params)
	return response

def uploadURL(key, identifier):
	params = {'apikey': key, 'url': identifier}
	response = requests.post('https://www.virustotal.com/vtapi/v2/url/scan', data=params)
	return response

def getFile(key, identifier):
    params = {'apikey': key, 'resource': identifier}
    report = requests.get('https://www.virustotal.com/vtapi/v2/file/report', params=params)
    return report

def getURL(key, url):
	params = {'apikey': key, 'resource': url}
	report = requests.post('https://www.virustotal.com/vtapi/v2/url/report', params=params)
	return report

def sendEmail(identifier, report):
        server = smtplib.SMTP("smtp.gmail.com", 587)
        email = identifier
        password = raw_input("Email Password: ")
        recipient = raw_input("Recepient: ")
        server.ehlo()
        server.starttls()
        server.login(email, password)
        
        server.sendmail(email, report)
        server.close
        
def main():
    parser = argparse.ArgumentParser(description="VirusTotal Upload")
    parser.add_argument('key', help="Enter API key")
    parser.add_argument('--file', help='Enter file location')
    parser.add_argument('--url', help='Enter file URL')
    parser.add_argument('--reportType', help="Enter report type")
    parser.add_argument('--identifier', help="Enter id to get report")
    parser.add_argument('--email', help='Enter email to send results to')

    args = parser.parse_args()
    report = NULL

    if args.file:
        response = uploadFile(args.key, args.file)
        print response.json()
    elif args.url:
        response = uploadURL(args.key, args.url)
        print response.json()

    if args.reportType = "url":
        report = getURL(args.key, args.identifier)
    else:
        report = getFile(args.key, args.identifier)

    if args.email:
        sendEmail(args.email, report)



if __name__ == "__main__": main()