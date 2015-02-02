var Mohammed = {};
  Mohammed.webdb = {};
  Mohammed.webdb.db = null;
  Mohammed.webdb.open = function() {
      var dbSize = 5 * 1024 * 1024; // 5MB
      Mohammed.webdb.db = openDatabase("Todo", "1.0", "Todo manager", dbSize);
  }
  Mohammed.webdb.createTable = function() {
      var db = Mohammed.webdb.db;
      db.transaction(function(tx) {
          tx.executeSql("CREATE TABLE IF NOT EXISTS todo(ID INTEGER PRIMARY KEY ASC, todo TEXT, added_on DATETIME)", []);
      });
  }
  Mohammed.webdb.addTodo = function(todoText) {
      var db = Mohammed.webdb.db;
      db.transaction(function(tx) {
          var addedOn = new Date();
          tx.executeSql("INSERT INTO todo(todo, added_on) VALUES (?,?)", [todoText, addedOn], Mohammed.webdb.onSuccess, Mohammed.webdb.onError);
      });
  }
  Mohammed.webdb.onError = function(tx, e) {
      alert("There has been an error: " + e.message);
  }
  Mohammed.webdb.onSuccess = function(tx, r) {
      // re-render the data.
      Mohammed.webdb.getAllTodoItems(loadTodoItems);
  }
  Mohammed.webdb.getAllTodoItems = function(renderFunc) {
      var db = Mohammed.webdb.db;
      db.transaction(function(tx) {
          tx.executeSql("SELECT * FROM todo", [], renderFunc, Mohammed.webdb.onError);
      });
  }
  Mohammed.webdb.deleteTodo = function(id) {
      var db = Mohammed.webdb.db;
      db.transaction(function(tx) {
          tx.executeSql("DELETE FROM todo WHERE ID=?", [id], Mohammed.webdb.onSuccess, Mohammed.webdb.onError);
      });
  }

  function loadTodoItems(tx, rs) {
      var rowOutput = "";
      var todoItems = document.getElementById("todoItems");
      for (var i = 0; i < rs.rows.length; i++) {
          rowOutput += renderTodo(rs.rows.item(i));
      }
      todoItems.innerHTML = rowOutput;
  }

  function renderTodo(row) {
      return "<li><span><cite>" + row.ID + "<\/cite><\/span><p>" + row.todo + "<\/p><span><a href='javascript:void(0);'  onclick='Mohammed.webdb.deleteTodo(" + row.ID + ");'>Delete<\/a><\/span><\/li>";
  }

  function init() {
      Mohammed.webdb.open();
      Mohammed.webdb.createTable();
      Mohammed.webdb.getAllTodoItems(loadTodoItems);
  }

  function addTodo() {
      var todo = document.getElementById("todo");
      Mohammed.webdb.addTodo(todo.value);
      todo.value = "";
  }