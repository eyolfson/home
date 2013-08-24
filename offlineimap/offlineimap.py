import subprocess

gmail_local_dict = {'inbox': 'INBOX',
                    'drafts': '[Gmail]/Drafts',
                    'sent': '[Gmail]/Sent Mail',
                    'spam': '[Gmail]/Spam',
                    'trash': '[Gmail]/Trash'}

gmail_remote_dict = {'INBOX': 'inbox',
                     '[Gmail]/Drafts': 'drafts',
                     '[Gmail]/Sent Mail': 'sent',
                     '[Gmail]/Spam': 'spam',
                     '[Gmail]/Trash': 'trash'}

uwaterloo_local_dict = {'inbox': 'INBOX',
                        'drafts': 'INBOX.Drafts',
                        'sent': 'INBOX.Sent',
                        'spam': 'INBOX.SPAM',
                        'trash': 'INBOX.Trash'}

uwaterloo_remote_dict = {'INBOX': 'inbox',
                         'INBOX.Drafts': 'drafts',
                         'INBOX.Sent': 'sent',
                         'INBOX.SPAM': 'spam',
                         'INBOX.Trash': 'trash'}

def pass_show(account):
    o = subprocess.check_output(['pass', 'show', 'email/{}'.format(account)])
    return o.strip()

def gmail_folderfilter(folder):
    if folder == '[Gmail]/All Mail':
        return False
    return True

def gmail_local_nametrans(folder):
    if folder in gmail_local_dict:
        return gmail_local_dict[folder]
    return folder

def gmail_remote_nametrans(folder):
    if folder in gmail_remote_dict:
        return gmail_remote_dict[folder]
    return folder

def uwaterloo_local_nametrans(folder):
    if folder in uwaterloo_local_dict:
        return uwaterloo_local_dict[folder]
    return folder

def uwaterloo_remote_nametrans(folder):
    if folder in uwaterloo_remote_dict:
        return uwaterloo_remote_dict[folder]
    return folder
