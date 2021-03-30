#TO-DO list

[![Build Status](https://travis-ci.org/o-gen18/job4j_todo.svg?branch=master)](https://travis-ci.org/o-gen18/job4j_todo)

This is simple to-do list web-app. Once you have logged in you can submit a task typing the text into textarea and pushing the submit button.
All tasks are ordered in the descending order by creation date.

![img](./img/to-do.png)

If you do not have an account yet, you can create one by pushing "register" button in the "Log in" from. 
Enter your name, email, password, and choose your role.
You can type any new role if you want.

![img](./img/register.png)

Tick the "Show All" checkbox to hide or show the done tasks.

![img](./img/hideDoneTasks.png)

Once you have logged in or registered you are allowed to create, update, or delete an item.  

Click the cross to set the task done and visa versa.

![img](./img/setStatusDone.png)

Click the task to change it. All changes to the tasks go to the database. 

![img](./img/editDescription.png)

Note that if a task becomes updated either by changing its done status or by typing another description, 
the task's author also changes to the latest one who updated it.

![img](./img/update.png)
