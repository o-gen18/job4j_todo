<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <!-- Popper JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <!-- Latest compiled JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <title>TODO list</title>
    <style>
        .popUpWindowBackground, .logInPopUp, .registerPopUp{
            display: none;
            position: fixed;
            overflow: auto;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgb(0,0,0);
            background-color: rgba(0,0,0,0.4);
        }
        .popUpWindow, .logInWindow, .registerWindow{
            background-color: #fefefe;
            margin: 5% auto 15% auto;
            border: 1px solid #888;
            width: 80%;
        }
    </style>
    <script>
        function userRegistered() {
            <%if (session.getAttribute("user") == null) {%>
            alert('Please, log in');
            return false;
            <%} else {%>
            return true;
            <%}%>
        }

        function validate() {
            if (!userRegistered()) {
                return false;
            }
            var task = document.getElementById('description').value;
            if (task === '') {
                alert('Please, type the description of the task!');
                return false;
            }
            var selectedCategories = [];
            for (var option of document.getElementById('cIds').options) {
                if (option.selected) {
                    selectedCategories.push(option.value);
                }
            }
            if (selectedCategories.length === 0) {
                alert('Please, choose at least one category for the task!');
                return false;
            }
            postTask(task, selectedCategories);
        }

        function postTask(task, selectedCategories) {
            $.ajax({
                method: 'POST',
                url: 'http://localhost:8080/job4j_todo/todo',
                traditional: true,
                data: {description: task,
                selectedCategories: selectedCategories},
                async: false,
                success: function () {
                    location.reload();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert('textStatus: ' + textStatus + '\n' + 'errorThrown: ' + errorThrown + '\n' + 'responseText:' + jqXHR.responseText
                    + '\n' + 'jqXHR.statusText: ' + jqXHR.statusText);
                }
            });
        }

        function deleteTask(tableRow) {
            if (!userRegistered()) {
                return false;
            }
            $.ajax({
                method: 'POST',
                url: 'http://localhost:8080/job4j_todo/delete',
                data: {id: tableRow.getAttribute('id')}
            }).done(function () {
                location.reload();
            });
        }

        function updateTask(tableRow, setDone) {
            if (!userRegistered()) {
                return false;
            }
            $.ajax({
                method: 'POST',
                url: 'http://localhost:8080/job4j_todo/todo',
                traditional: true,
                data: {
                    id: tableRow.getAttribute('id'),
                    description: tableRow.getElementsByClassName('descriptionText')[0].innerText,
                    categoryIds: tableRow.getElementsByClassName('category')[0]
                        .getAttribute('data-categoryId').split(',')
                        .map(function(i) {
                        return parseInt(i, 10);
                    }),
                    created: Date.parse(tableRow.getElementsByClassName('created')[0].innerHTML),
                    done: setDone},
                success: function () {
                    location.reload();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert('textStatus: ' + textStatus + '\n' + 'errorThrown: ' + errorThrown + '\n' + 'responseText:' + jqXHR.responseText
                        + '\n' + 'jqXHR.statusText: ' + jqXHR.statusText);
                }
            });
        }

        function getTasks() {
            $.ajax({
                method: 'GET',
                url: 'http://localhost:8080/job4j_todo/todo',
                dataType: 'json'
            }).done(function (data) {
                var jsonResp = JSON.parse(JSON.stringify(data));
                for (var i in jsonResp) {
                    var desc = jsonResp[i].name;
                    var category = '';
                    var categoryId = [];
                    for (var categ of JSON.parse(JSON.stringify(jsonResp[i].categories))) {
                        category += categ.name + '\n';
                        categoryId.push(categ.id);
                    }
                    $('#tableBody').append(
                        '<tr id="'+ jsonResp[i].id + '">\n' +
                        '                <td>\n' +
                        '                    <a class="popUpTrash" title="delete" style="cursor: pointer; color:black; text-decoration: none" onclick="deleteTask(this.closest(\'tr\'))">\n' +
                        '                        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash" viewBox="0 0 16 16">\n' +
                        '                            <path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/>\n' +
                        '                            <path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4L4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/>\n' +
                        '                        </svg>\n' +
                        '                    </a>\n' +
                        '                    <a class="descriptionText" title="change the description" style="cursor: pointer; color:black" onclick="popUpEdit(this.closest(\'tr\'))">' + desc + '</a>\n' +
                        '                </td>\n' +
                        '                <td class="category" data-categoryId=\"' + categoryId + '\">' + category + '</td>\n' +
                        '                <td class="created">'+ new Date(jsonResp[i].created) +'</td>\n' +
                        '                <td class="author">'+ jsonResp[i].author.name +'</td>\n' +
                        '                <td class="author-role">'+ jsonResp[i].author.role.name +'</td>\n' +
                        '                <td class="doneSymbol">\n' + renderDone(jsonResp[i].done) +
                        '                </td>\n' +
                        '            </tr>'
                    );
                }
                showAll(document.getElementById('checkbox'));
            })
        }

        function getCategories() {
            $.ajax({
                method: 'GET',
                url: 'http://localhost:8080/job4j_todo/category',
                dataType: 'json'
            }).done(function (data) {
                var categoies = JSON.parse(JSON.stringify(data));
                for (var i in categoies) {
                    $('#cIds').append(
                        '<option value=\"' + categoies[i].id + '\">' + categoies[i].name +'</option>'
                    );
                }
            })
        }

        function renderDone(boolean) {
            if (boolean === true) {
                return'<a class="status" data-isDone="true" title="set undone" onclick="return updateTask(this.closest(\'tr\'), false)">\n' +
                    '                    <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-check" viewBox="0 0 16 16" style="color: #008000; cursor: pointer">\n' +
                    '                    <path d="M10.97 4.97a.75.75 0 0 1 1.07 1.05l-3.99 4.99a.75.75 0 0 1-1.08.02L4.324 8.384a.75.75 0 1 1 1.06-1.06l2.094 2.093 3.473-4.425a.267.267 0 0 1 .02-.022z"/>\n' +
                    '                </svg>\n' +
                    '                </a>';
            } else {
                return '<a class="status" data-isDone="false" title="set done" onclick="return updateTask(this.closest(\'tr\'), true)">\n' +
                    '                    <svg xmlns="http://www.w3.org/2000/svg" width="26" height="26" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16" style="color: red; cursor: pointer">\n' +
                    '                    <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>\n' +
                    '               </svg>\n' +
                    '                </a>';
            }
        }

        function showAll(checkbox) {
            var done = document.getElementsByClassName('status');
            for (var i = 0; i < done.length; i++) {
                if (done[i].getAttribute('data-isDone') === 'true') {
                    if (checkbox.checked) {
                        done[i].closest('tr').style.display = 'table-row';
                    } else {
                        done[i].closest('tr').style.display = 'none';
                    }
                }
            }
        }

        function popUpEdit(tableRow) {
            document.getElementsByClassName('popUpWindowBackground')[0].style.display = 'block';
            var editDescription = document.getElementById('editDescription');
            editDescription.value = tableRow.getElementsByClassName('descriptionText')[0].innerText;
            editDescription.setAttribute('data-tempId', tableRow.getAttribute('id'));
        }

        function changeDescription() {
            var editDescription = document.getElementById('editDescription');
            var oldTableRow = document.getElementById(editDescription.getAttribute('data-tempId'));
            var oldDescription = oldTableRow.getElementsByClassName('descriptionText')[0].innerText;
            var newDescription = editDescription.value;
            var isDone = oldTableRow.getElementsByClassName('status')[0].getAttribute('data-isDone');
            if (newDescription === '' || oldDescription === newDescription) {
                alert('The input should distinct from the old description and not be empty!');
                return false;
            }
            oldTableRow.getElementsByClassName('descriptionText')[0].innerText = newDescription;
            updateTask(oldTableRow, isDone);
        }

        window.onclick = function(event) {
            var popUpEdit = document.getElementsByClassName('popUpWindowBackground')[0];
            var popUpLogin = document.getElementsByClassName('logInPopUp')[0];
            var popUpRegister = document.getElementsByClassName('registerPopUp')[0];
            if (event.target === popUpEdit) {
                popUpEdit.style.display = "none";
            } else if (event.target === popUpLogin) {
                popUpLogin.style.display = "none";
            } else if (event.target === popUpRegister) {
                popUpRegister.style.display = "none";
            }
        }

        function logIn() {
            var email = document.getElementById('logInEmail').value;
            var password = document.getElementById('logInPassword').value;
            if (email === '' || password === '') {
                alert('Fill in both fields, please!');
                return false;
            }
            $.ajax({
                method: 'POST',
                url: 'http://localhost:8080/job4j_todo/auth',
                data: {
                    email: email,
                    password: password
                },
                success: function () {
                    location.reload();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert('Wrong password or email!');
                    return false;
                }
            });
        }

        function signIn() {
            var name = document.getElementById('signInName').value;
            var email = document.getElementById('signInEmail').value;
            var password = document.getElementById('signInPassword').value;
            var role = document.getElementById('signInRole').value;
            if (name === '' || email === '' || password === '' || role === '') {
                alert('Fill in all the forms!');
                return false;
            }
            $.ajax({
                method: 'POST',
                url: 'http://localhost:8080/job4j_todo/register',
                data: {
                    email: email,
                    password: password,
                    name: name,
                    role: role
                },
                success: function () {
                    location.reload();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert('This email already exists, enter different!');
                }
            });
        }

        function loadRoles() {
            $.ajax({
                method: 'GET',
                url: 'http://localhost:8080/job4j_todo/role',
                dataType: 'json'
            }).done(function(roles) {
                var jsonRoles = JSON.parse(JSON.stringify(roles));
                for (var i in jsonRoles) {
                    $('#roles').append('<option value="' + jsonRoles[i].name + '">');
                }
            }).fail(function(jqXHR, textStatus, errorThrown) {
                alert('textStatus: ' + textStatus + '\n' + 'errorThrown: ' + errorThrown + '\n' + 'responseText:' + jqXHR.responseText
                    + '\n' + 'jqXHR.statusText: ' + jqXHR.statusText);
            });
        }

        function logOut() {
            $.ajax({
                method: 'GET',
                url: 'http://localhost:8080/job4j_todo/logOut'
            }).done(function (data) {
                location.reload();
            });
        }
    </script>
</head>
<body onload="getTasks();getCategories(); loadRoles()">
<div class="container-fluid">
    <h1 align="center">ToDo-list</h1>
</div>
<div class="container" style="width:75%; text-align-last: right">
        <c:choose>
            <c:when test="${user.name == null}">
            <a onclick="document.getElementsByClassName('logInPopUp')[0].style.display = 'block'" style="cursor: pointer; font-weight: bold">Log in</a>
            </c:when>
            <c:otherwise>
                <a onclick="logOut()" style="cursor: pointer; color: green; font-weight: bold"><c:out value="${user.name} - ${user.role.name}"/> | Log out</a>
            </c:otherwise>
        </c:choose>
</div>
<div class="container" style="width:75%">
    <form>
        <div class="form-group">
            <label for="description">Add new task: </label>
            <textarea id="description" class="form-control" placeholder="Type description..."></textarea>
        </div>
        <div class="form-group">
            <label for="cIds">Task's categories: </label>
            <select class="form-control" name="cIds" id="cIds" multiple>
            </select>
        </div>
        <input type="button" class="btn btn-primary" value="Submit" onclick="return validate()">
    </form>
    <div class="form-check" align="center">
        <h3>Existing tasks</h3>
        <label class="form-check-label">
            <input id="checkbox" type="checkbox" checked="checked" autocomplete="off" class="form-check-input" onclick="showAll(this)">Show all
        </label>
    </div>
    <div class="form-group">
        <table class="table table-hover">
            <thead>
            <tr>
                <th>Description</th>
                <th>Category</th>
                <th>Created</th>
                <th>Author</th>
                <th>Role</th>
                <th>Done</th>
            </tr>
            </thead>
            <tbody id="tableBody">
            </tbody>
        </table>
    </div>
    <div class="popUpWindowBackground">
        <form class="popUpWindow">
            <div class="container">
                <label for="editDescription"><b>Edit description</b></label>
                <textarea id="editDescription" class="form-control" name="description"></textarea>
            </div>
            <div class="container">
                <button type="button" class="btn btn-primary" onclick="changeDescription()">Edit</button>
            </div>
        </form>
    </div>
    <div class="logInPopUp">
        <div class="form-group logInWindow">
            <form class="logInForm">
                <div class="container-fluid">
                    <label for="logInEmail"><b>Email: </b></label><input id="logInEmail" class="form-control" type="email">
                    <label for="logInPassword"><b>Password: </b></label><input id="logInPassword"class="form-control" type="password">
                </div>
                <div class="container-fluid">
                    <button type="button" class="btn btn-primary" onclick="logIn()">Log In</button>
                    <button type="button" class="btn btn-primary" onclick="document.getElementsByClassName('registerPopUp')[0].style.display = 'block'">Register</button>
                </div>
            </form>
        </div>
    </div>
    <div class="registerPopUp">
        <div class="form-group registerWindow">
            <form class="registerForm">
                <div class="container-fluid">
                    <label for="signInName"><b>Name: </b></label><input id="signInName" class="form-control" type="text">
                    <label for="signInEmail"><b>Email: </b></label><input id="signInEmail" class="form-control" type="email">
                    <label for="signInPassword"><b>Password: </b></label><input id="signInPassword" class="form-control" type="password">
                    <label for="signInRole"><b>Role: </b></label>
                    <input id="signInRole" list="roles" class="form-control" placeholder="Select a role">
                    <datalist id="roles"></datalist>
                    <div class="container-fluid">
                        <button type="button" class="btn btn-primary" onclick="signIn()">Sign In</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>