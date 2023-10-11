## NOTES

## Ansible Run Options 

1. `--check`: This option(flag) is passed to the playbook to dry run. It doesn't actually execute the resource but check if there's any configuration failure

```sh
# playbook.ym
---
- name: Install http
  hosts: all
  tasks:
  - name: Install http
    service: 
      name: http
      state: installed
---

# Run playbook with --check flag 
ansible-playbook playbook.yml --check
```

2. `--start-at-task`: This flag allows you to start from the task you want to begin from running from. Any tasks above the chosen task is ignored

```sh
# playbook.yml
---
- name: Install http
  hosts: all
  tasks:
  - name: Install http
    service:
      name: http
      state: installed
      
  - name: Start http service
    service:
      name: http
      state: started
---

# Run command with selected task
ansible-playbook playbook.yml --start-at-task "Start httpd service"
```

3. `--tags`: This allows you to ONLY run tasks that are tagged

```sh
# playbook.yml
---
- name: Install http
  hosts: all
  tasks:
  - name: Install http
    yum:
      name: http
      state: installed
    tags: intall

  - name: Start http service
    service:
      name: http
      state: started

# Run playbook with --tags to only run the "Install http" task
ansible-playbook playbook.yml --tags "install"
---
```

4. `--skip-tags`: Likewise, you can run tasks by skipping those that tagged. Use same example above

```sh
# Run playbook with --skip-tags //the second task will run
ansible-playbook playbook.yml --skip-tags "install"
```
