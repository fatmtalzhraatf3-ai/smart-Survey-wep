<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Smart Survey Web App</title>

<!-- Excel Library -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<style>
body{
    font-family: Arial;
    margin:40px;
    background:#f4f6f8;
}

h1{
    color:#0b5ed7;
}

.container{
    background:white;
    padding:20px;
    border-radius:10px;
    box-shadow:0 0 10px rgba(0,0,0,0.1);
    margin-bottom:20px;
}

input, button{
    margin:8px;
    padding:8px;
}

button{
    background:#198754;
    color:white;
    border:none;
    cursor:pointer;
    border-radius:5px;
}

button:hover{
    background:#146c43;
}

#output{
    margin-top:20px;
    padding:15px;
    background:#eef2f7;
    border-radius:8px;
}
</style>
</head>

<body>

<h1>Smart Survey Web Application</h1>

<div class="container">
<h2>📊 Grid Leveling (Cut & Fill)</h2>

<p>Upload Excel File:</p>
<input type="file" id="fileInput">

<br>
<button onclick="processLevel()">Calculate Quantities</button>
</div>

<div class="container">
<h2>📐 Traverse Adjustment</h2>

<label>Total Measured Length:</label>
<input id="measured" type="number">

<label>True Length:</label>
<input id="trueLength" type="number">

<br>
<button onclick="adjustTraverse()">Adjust Traverse</button>
</div>

<div id="output"></div>

<script>

let workbook;

// read excel
document.getElementById("fileInput").addEventListener("change", function(e){

    const reader = new FileReader();

    reader.onload = function(e){
        const data = new Uint8Array(e.target.result);
        workbook = XLSX.read(data, {type:'array'});
    };

    reader.readAsArrayBuffer(e.target.files[0]);
});


// leveling calculations
function processLevel(){

    if(!workbook){
        alert("Upload Excel file first");
        return;
    }

    const sheet = workbook.Sheets[workbook.SheetNames[0]];
    const json = XLSX.utils.sheet_to_json(sheet);

    let totalCut = 0;
    let totalFill = 0;

    let result = "<h3>Leveling Results</h3>";

    json.forEach(row => {

        let RL = row.HI - row.Reading;

        let cut = Math.max(0, RL - row.Design);
        let fill = Math.max(0, row.Design - RL);

        totalCut += cut;
        totalFill += fill;

        result += `
        Point: ${row.Point}
        | RL: ${RL.toFixed(3)}
        | Cut: ${cut.toFixed(3)}
        | Fill: ${fill.toFixed(3)} <br>`;
    });

    result += `<hr>
    <b>Total Cut = ${totalCut.toFixed(3)}</b><br>
    <b>Total Fill = ${totalFill.toFixed(3)}</b>`;

    document.getElementById("output").innerHTML = result;
}


// traverse correction
function adjustTraverse(){

    let measured = parseFloat(document.getElementById("measured").value);
    let trueLen = parseFloat(document.getElementById("trueLength").value);

    if(!measured || !trueLen){
        alert("Enter values first");
        return;
    }

    let correction = trueLen - measured;
    let ratio = correction / measured;

    document.getElementById("output").innerHTML =
    `<h3>Traverse Adjustment Result</h3>
     Total Correction = ${correction.toFixed(3)} m<br>
     Correction Ratio = ${ratio.toFixed(6)}`;
}

</script>

</body>
</html>
