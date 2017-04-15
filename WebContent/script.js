function createDB(e) {
       e.style.display = "none";
       document.getElementById("cancel-db").style.display = "initial"; 
       document.getElementById("create-db-submit").style.display = "initial";
       document.getElementById("create-db-input").style.display = "initial";

}

function cancelDB(e) {
	e.style.display = "none";
	document.getElementById("create-db-btn").style.display = "initial";
	document.getElementById("create-db-submit").style.display = "none";
    document.getElementById("create-db-input").style.display = "none";
	
	
}