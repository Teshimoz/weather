<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

<head>
  <title>Weather</title>
</head>

<body>


<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

<h1>{time}</h1>
<div><font color="#F40000">Temperature outdoor: {temperature} &deg{temperature_unit}</font></div>
<div><font color="#ff7f24">Temperature  indoor: {temperature_indoor} &deg{temperature_unit_indoor}</font></div>
<div><font color="#ba808c">Temperature  delta: {temperature_delta} &deg{temperature_unit_delta}</font></div>
<div><font color="#351c75">CO2 level: {co2} {co2_unit}</font></div>

<div><font color="#0000FF">Humidity outdoor: {humidity} %</font></div>
<div><font color="#3399FF">Humidity  indoor: {humidity_indoor} %</font></div>
<div><font color="#008040">Pressure: {pressure} {pressure_unit}</font></div>
<!--
<div><font color="#007f99">Power status: {rainstate}</font></div>

-->
<h1>Last 24 hours</h1>

<div id="chart_divTemperature24h" width="400"></div>
<!--<div id="chart_divTemperature24h_indoor" width="400"></div>-->
<div id="chart_divTemperature24h_delta" width="400"></div>
<div id="chart_divCo224h" width="400"></div>

<div id="chart_divHumidity24h" width="400"></div>
<div id="chart_divHumidity24h_indoor" width="400"></div>
<div id="chart_divPressure24h" width="400"></div>
<!--<div id="chart_divRainstate24h" width="400"></div>-->


<h1>Last week</h1>

<div id="chart_divTemperature7d" width="400"></div>
<!--<div id="chart_divTemperature7d_indoor" width="400"></div>-->
<div id="chart_divdelta7d" width="400"></div>
<div id="chart_divCo27d" width="400"></div>

<div id="chart_divHumidity7d" width="400"></div>
<div id="chart_divHumidity7d_indoor" width="400"></div>
<div id="chart_divPressure7d" width="400"></div>
<!--<div id="chart_divRainstate7d" width="400"></div>-->


<h1>Last month</h1>

<div id="chart_divTemperature30d" width="400"></div>
<!--<div id="chart_divTemperature30d_indoor" width="400"></div>-->
<div id="chart_divdelta30d" width="400"></div>
<div id="chart_divCo230d" width="400"></div>

<div id="chart_divHumidity30d" width="400"></div>
<div id="chart_divHumidity30d_indoor" width="400"></div>
<div id="chart_divPressure30d" width="400"></div>
<div id="chart_divRainstate30d" width="400"></div>


<script>
google.charts.load('current', {packages: ['corechart', 'line']});


//---- temperature 24 hours
function drawTemperature24() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'outdoor, \u00B0{temperature_unit}');
      data.addColumn('number', 'indoor, \u00B0{temperature_unit}'); //
      data.addRows([
        {temperature_combo24h}
        ]);
      var options = {
        title: 'Temperature outdoor and indoor\nMeans are {temperature_mean24h} {temperature_unit} and {temperature_indoor_mean24h} {temperature_unit} respectively',
        hAxis: {
          //format: 'dd.MM.yyyy HH:mm',
          format: 'HH:mm',
          title: 'Time',
        },
        vAxis: {
          title: 'Temperature, \u00B0{temperature_unit}',
          gridlines: { count: 6 },
          //minValue: 20,
          //maxValue: 40
        },
        colors: ['#F40000', '#ff7f24'],
        //width:2000,
        height: 300,
        lineWidth: 2
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divTemperature24h'), ('chart_divTemperature24h_indoor'));
      chart.draw(data, options);
    }


//---- temperature indoor 24 hours

<!--function drawTemperature24_indoor() {-->
<!--      var data = new google.visualization.DataTable();-->
<!--      data.addColumn('datetime', 'X');-->
<!--      data.addColumn('number', 'Temperature indoor, \u00B0{temperature_unit_indoor}');   // side text-->

<!--      data.addRows([-->
<!--{temperature_indoor24h}-->
<!--      ]);-->

<!--      var options = {-->
<!--        title: 'Temperature indoor',-->
<!--        hAxis: {-->
<!--          format: 'HH:mm',-->
<!--          logScale: false-->
<!--        },-->
<!--        vAxis: {-->
<!--          title: 'Temperature indoor, \u00B0{temperature_unit_indoor}',-->
<!--          logScale: false-->
<!--        },-->
<!--        colors: ['#ff7f24'],-->
<!--        height: 300-->
<!--      };-->

<!--      var chart = new google.visualization.LineChart(document.getElementById('chart_divTemperature24h_indoor'));-->
<!--      chart.draw(data, options);-->
<!--    }-->


//---- temperature delta 24 hours

function drawTemperature24_delta() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'Temperature delta, \u00B0{temperature_unit_delta}');
      data.addRows([
{temperature_delta24h}
      ]);

      var options = {
        title: 'Temperature delta\nMean is {temperature_delta_mean24h} {temperature_unit}',
        hAxis: {
          format: 'HH:mm',
          logScale: false
        },
        vAxis: {
          title: 'delta, \u00B0{temperature_unit_delta}',
          logScale: false
        },
        colors: ['#ba808c'],
        height: 300
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divTemperature24h_delta'));
      chart.draw(data, options);
    }


//---- pressure 24 hours

function drawPressure24() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'Pressure, {pressure_unit}');

      data.addRows([
{pressure24h}
      ]);

      var options = {
        title: 'Pressure\nMean is {pressure_mean24h} {pressure_unit}',
        hAxis: {
          format: 'HH:mm',
          logScale: false
        },
        vAxis: {
          title: 'Pressure, {pressure_unit}',
        },
        colors: ['#008040'],
        height: 200
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divPressure24h'));
      chart.draw(data, options);
    }


//---- humidity 24 hours

function drawHumidity24() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'outdoor, %');
      data.addColumn('number', 'indoor, %');
      data.addRows([
{humidity_combo24h}
      ]);

      var options = {
        title: 'Humidity outdoor and indoor\nMeans are {humidity_mean24h} {humidity_unit} and {humidity_indoor_mean24h} {humidity_unit} respectively',
        hAxis: {
          format: 'HH:mm',
        },
        vAxis: {
          title: 'Humidity, %',
          logScale: false,
          gridlines: { count: 6 },
          minValue: 0,
          maxValue: 100
        },
        colors: ['#0000FF', '#3399FF'],
        height: 200
      };

      var chartH = new google.visualization.LineChart(document.getElementById('chart_divHumidity24h'));
      chartH.draw(data, options);
    }


//---- humidity indoor 24 hours

<!--function drawHumidity24_indoor() {-->
<!--      var data = new google.visualization.DataTable();-->
<!--      data.addColumn('datetime', 'X');-->
<!--      data.addColumn('number', 'Humidity, %');-->
<!--      data.addRows([-->
<!--{humidity_indoor24h}-->
<!--      ]);-->

<!--      var options = {-->
<!--        title: 'Humidity indoor',-->
<!--        hAxis: {-->
<!--          format: 'HH:mm',-->
<!--          logScale: false-->
<!--        },-->
<!--        vAxis: {-->
<!--          title: 'Humidity, %',-->
<!--          logScale: false,-->
<!--          gridlines: { count: 6 },-->
<!--          minValue: 0,-->
<!--          maxValue: 100-->
<!--        },-->
<!--        colors: ['#3399FF'],-->
<!--        height: 150-->
<!--      };-->

<!--      var chartH = new google.visualization.LineChart(document.getElementById('chart_divHumidity24h_indoor'));-->
<!--      chartH.draw(data, options);-->
<!--    }-->


//---- rain (power) 24 hours

<!--function drawRainstate24() {-->
<!--      var data = new google.visualization.DataTable();-->
<!--      data.addColumn('datetime', 'X');-->
<!--      data.addColumn('number', 'Power status');   // side text-->

<!--      data.addRows([-->
<!--{rainstate24h}-->
<!--      ]);-->

<!--      var options = {-->
<!--        title: 'Power status',-->
<!--        hAxis: {-->
<!--          format: 'HH:mm',-->
<!--          logScale: false-->
<!--        },-->
<!--        vAxis: {-->
<!--          title: 'Power status',-->
<!--          gridlines: { count: 1 },-->
<!--          minValue: 0,-->
<!--          maxValue: 1-->
<!--        },-->
<!--        colors: ['#444466'],-->
<!--        height: 95-->
<!--      };-->

<!--      var chart = new google.visualization.LineChart(document.getElementById('chart_divRainstate24h'));-->
<!--      chart.draw(data, options);-->
<!--    }-->


//---- CO2 24 hours

function drawCo224() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'ppm');   // side text
      data.addRows([
{co224h}
      ]);

      var options = {
        title: 'CO2 level\nMean is {co2_mean24h} {co2_unit}',
        hAxis: {
          format: 'HH:mm',
          logScale: false
        },
        vAxis: {
          title: 'CO2, {co2_unit}',
          gridlines: { count: 5 },
        },
        colors: ['#351c75'],
        height: 200
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divCo224h'));
      chart.draw(data, options);
    }



//-----------------7 days part --------------------------------------------------------------
//---- temperature 7 days

function drawTemperature7d() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'outdoor, \u00B0{temperature_unit}');
      data.addColumn('number', 'indoor, \u00B0{temperature_unit}');
      data.addRows([
{temperature_combo7d}
      ]);

      var options = {
        title: 'Temperature outdoor and indoor\nMeans are {temperature_mean7d} {temperature_unit} and {temperature_indoor_mean7d} {temperature_unit} respectively',
        hAxis: {
          format: 'dd.MM',

          logScale: false
        },
        vAxis: {
          title: 'Temperature, \u00B0{temperature_unit}',
          logScale: false
        },
        colors: ['#F40000', '#ff7f24'],
                height: 300
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divTemperature7d'));
      chart.draw(data, options);
    }

//---- temperature indoor 7 days

<!--function drawTemperature7d_indoor() {-->
<!--      var data = new google.visualization.DataTable();-->
<!--      data.addColumn('datetime', 'X');-->
<!--      data.addColumn('number', 'temperature_indoor, \u00B0{temperature_unit}');-->
<!--      data.addRows([-->
<!--{temperature_indoor7d}-->
<!--      ]);-->

<!--      var options = {-->
<!--        title: 'Temperature indoor',-->
<!--        hAxis: {-->
<!--          format: 'dd.MM',-->

<!--          logScale: false-->
<!--        },-->
<!--        vAxis: {-->
<!--          title: 'Temperature indoor, \u00B0{temperature_unit}',-->
<!--          logScale: false-->
<!--        },-->
<!--        colors: ['#ff7f24'],-->
<!--        height: 300-->
<!--      };-->

<!--      var chart = new google.visualization.LineChart(document.getElementById('chart_divTemperature7d_indoor'));-->
<!--      chart.draw(data, options);-->
<!--    }-->


//---- temperature delta 7 days

function drawdelta7d() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'Temperature delta, \u00B0{temperature_unit}');
      data.addRows([
{temperature_delta7d}
      ]);

      var options = {
        title: 'Temperature delta\nMean is {temperature_delta_mean7d} {temperature_unit}',
        hAxis: {
          format: 'dd.MM',
          logScale: false
        },
        vAxis: {
          title: 'delta, \u00B0{temperature_unit}',
          logScale: false
        },
        colors: ['#ba808c'],
        height: 300
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divdelta7d'));
      chart.draw(data, options);
    }


//---- pressure 7 days

function drawPressure7d() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'Pressure, {pressure_unit}');
      data.addRows([
{pressure7d}
      ]);

      var options = {
        title: 'Pressure\nMean is {pressure_mean7d} {pressure_unit}',
        hAxis: {
          format: 'dd.MM',
          logScale: false
        },
        vAxis: {
          title: 'Pressure, {pressure_unit}',
          logScale: false,
          minValue: 750,
          maxValue: 760
        },
        colors: ['#008040'],
        height: 200
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divPressure7d'));
      chart.draw(data, options);
    }


//---- humidity 7 days

function drawHumidity7d() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'outdoor, %');
      data.addColumn('number', 'indoor, %');
      data.addRows([
{humidity_combo7d}
      ]);

      var options = {
        title: 'Humidity outdoor and indoor\nMeans are {humidity_mean7d} {humidity_unit} and {humidity_indoor_mean7d} {humidity_unit} respectively',
        hAxis: {
          format: 'dd.MM',
          logScale: false
        },
        vAxis: {
          title: 'Humidity, %',
          logScale: false,
          gridlines: { count: 6 },
          minValue: 0,
          maxValue: 100
        },
        colors: ['#0000FF', '#3399FF'],
        height: 200
      };

      var chartH = new google.visualization.LineChart(document.getElementById('chart_divHumidity7d'));
      chartH.draw(data, options);
    }

//---- humidity indoor 7 days

<!--function drawHumidity7d_indoor() {-->
<!--      var data = new google.visualization.DataTable();-->
<!--      data.addColumn('datetime', 'X');-->
<!--      data.addColumn('number', 'Humidity, %');-->
<!--      data.addRows([-->
<!--{humidity_indoor7d}-->
<!--      ]);-->

<!--      var options = {-->
<!--        title: 'Humidity indoor',-->
<!--        hAxis: {-->
<!--          format: 'dd.MM',-->
<!--          //format: 'hh:mm',-->
<!--          //title: 'Time',-->
<!--          logScale: false,-->
<!--        },-->
<!--        vAxis: {-->
<!--          title: 'Humidity, %',-->
<!--          logScale: false,-->
<!--          gridlines: { count: 6 },-->
<!--          minValue: 0,-->
<!--          maxValue: 100-->
<!--        },-->
<!--        colors: ['#3399FF'],-->
<!--        height: 150-->
<!--      };-->

<!--      var chartH = new google.visualization.LineChart(document.getElementById('chart_divHumidity7d_indoor'));-->
<!--      chartH.draw(data, options);-->
<!--    }-->

//---- rain (power) 7 days

<!--function drawRainstate7d() {-->
<!--      var data = new google.visualization.DataTable();-->
<!--      data.addColumn('datetime', 'X');-->
<!--      data.addColumn('number', 'Power status');   // side text-->
<!--      data.addRows([-->
<!--{rainstate7d}-->
<!--      ]);-->

<!--      var options = {-->
<!--        title: 'Power status',-->
<!--        hAxis: {-->
<!--          format: 'dd.MM',-->
<!--          logScale: false-->
<!--        },-->
<!--        vAxis: {-->
<!--          title: 'Power status',-->
<!--          logScale: false,-->
<!--          gridlines: { count: 1 },-->
<!--          minValue: 0,-->
<!--          maxValue: 1-->
<!--        },-->
<!--        colors: ['#444466'],-->
<!--        height: 95-->
<!--      };-->

<!--      var chart = new google.visualization.LineChart(document.getElementById('chart_divRainstate7d'));-->
<!--      chart.draw(data, options);-->
<!--    }-->


//---- CO2 7 days

function drawCo27d() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', '{co2_unit}');   // side text
      data.addRows([
{co27d}
      ]);

      var options = {
        title: 'CO2 level\nMean is {co2_mean7d} {co2_unit}',
                hAxis: {
          format: 'dd.MM'
        },
        vAxis: {
          title: 'CO2, {co2_unit}',
          logScale: false,
          gridlines: { count: 5 },
        },
        colors: ['#351c75'],
        height: 200
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divCo27d'));
      chart.draw(data, options);
    }


//---------------- 30 days part -----------------------------------------------------------------
//---- temperature 30 days

function drawTemperature30d() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'outdoor, \u00B0{temperature_unit}');
      data.addColumn('number', 'indoor, \u00B0{temperature_unit}');
      data.addRows([
{temperature_combo30d}
      ]);

      var options = {
        title: 'Temperature outdoor and indoor\nMeans are {temperature_mean30d} {temperature_unit} and {temperature_indoor_mean30d} {temperature_unit} respectively',
        hAxis: {
          format: 'dd.MM',
          logScale: false
        },
        vAxis: {
          title: 'Temperature, \u00B0{temperature_unit}',
          logScale: false
        },
        colors: ['#F40000', '#ff7f24'],
        height: 300
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divTemperature30d'));
      chart.draw(data, options);
    }


//---- temperature indoor 30 days

<!--function drawTemperature30d_indoor() {-->
<!--      var data = new google.visualization.DataTable();-->
<!--      data.addColumn('datetime', 'X');-->
<!--      data.addColumn('number', 'temperature_indoor, \u00B0{temperature_unit}');-->
<!--      data.addRows([-->
<!--{temperature30d_indoor}-->
<!--      ]);-->

<!--      var options = {-->
<!--        title: 'Temperature indoor',-->
<!--        hAxis: {-->
<!--          format: 'dd.MM',-->
<!--          logScale: false-->
<!--        },-->
<!--        vAxis: {-->
<!--          title: 'Temperature indoor, \u00B0{temperature_unit}',-->
<!--          logScale: false-->
<!--        },-->
<!--        colors: ['#ff7f24'],-->
<!--        height: 300-->
<!--      };-->

<!--      var chart = new google.visualization.LineChart(document.getElementById('chart_divTemperature30d_indoor'));-->
<!--      chart.draw(data, options);-->
<!--    }-->


//---- temperature delta 30 days

function drawdelta30d() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'Temperature delta, \u00B0{temperature_unit}');
      data.addRows([
{temperature_delta30d}
      ]);

      var options = {
        title: 'Temperature delta\nMean is {temperature_delta_mean30d} {temperature_unit}',
        hAxis: {
          format: 'dd.MM'
        },
        vAxis: {
          title: 'delta, \u00B0{temperature_unit}',
          logScale: false
        },
        colors: ['#ba808c'],
        height: 300
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divdelta30d'));
      chart.draw(data, options);
    }


//---- pressure 30 days

function drawPressure30d() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'Pressure, {pressure_unit}');
      data.addRows([
{pressure30d}
      ]);

      var options = {
        title: 'Pressure\nMean is {pressure_mean30d} {pressure_unit}',
        hAxis: {
          format: 'dd.MM'
        },
        vAxis: {
          title: 'Pressure, {pressure_unit}',
          logScale: false
        },
        colors: ['#008040'],
        height: 200
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divPressure30d'));
      chart.draw(data, options);
    }

//---- humidity 30 days

function drawHumidity30d() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'outdoor, %');
      data.addColumn('number', 'indoor, %');
      data.addRows([
{humidity_combo30d}
      ]);

      var options = {
        title: 'Humidity outdoor and indoor\nMeans are {humidity_mean30d} {humidity_unit} and {humidity_indoor_mean30d} {humidity_unit} respectively',
        hAxis: {
          format: 'dd.MM'
        },
        vAxis: {
        title: 'Humidity, {humidity_unit}',
          gridlines: { count: 6 },
          minValue: 0,
          maxValue: 100
        },
        colors: ['#0000FF', '#3399FF'],
        height: 200
      };

      var chartH = new google.visualization.LineChart(document.getElementById('chart_divHumidity30d'));
      chartH.draw(data, options);
    }

//---- humidity indoor 30 days

<!--function drawHumidity30d_indoor() {-->
<!--      var data = new google.visualization.DataTable();-->
<!--      data.addColumn('datetime', 'X');-->
<!--      data.addColumn('number', 'Humidity, %');-->
<!--      data.addRows([-->
<!--{humidity_indoor30d}-->
<!--      ]);-->

<!--      var options = {-->
<!--        title: 'Humidity indoor',-->
<!--        hAxis: {-->
<!--          format: 'dd.MM',-->
<!--          logScale: false-->
<!--        },-->
<!--        vAxis: {-->
<!--          title: 'Humidity, %',-->
<!--          gridlines: { count: 6 },-->
<!--          minValue: 0,-->
<!--          maxValue: 100-->
<!--        },-->
<!--        colors: ['#3399FF'],-->
<!--        height: 150-->
<!--      };-->

<!--      var chartH = new google.visualization.LineChart(document.getElementById('chart_divHumidity30d_indoor'));-->
<!--      chartH.draw(data, options);-->
<!--    }-->


//---- rain (power) 30 days

function drawRainstate30d() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', 'Power status');   // side text

      data.addRows([
{rainstate30d}
      ]);

      var options = {
        title: 'Power status',
        hAxis: {
          //format: 'dd.MM.yyyy hh:mm',
          format: 'dd.MM',
          //title: 'Time',
          logScale: false
        },
        vAxis: {
          title: 'Power status',
          logScale: false,
          gridlines: { count: 1 },
          minValue: 0,
          maxValue: 1
        },
        colors: ['#444466'],
        height: 95
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divRainstate30d'));
      chart.draw(data, options);
    }


//---- CO2 30 days

function drawCo230d() {
      var data = new google.visualization.DataTable();
      data.addColumn('datetime', 'X');
      data.addColumn('number', '{co2_unit}');
      data.addRows([
{co230d}
      ]);

      var options = {
        title: 'CO2 Level\nMean is {co2_mean30d} {co2_unit}',
        hAxis: {
          format: 'dd.MM'
        },
        vAxis: {
          title: 'CO2, {co2_unit}',
          logScale: false
        },
        colors: ['#351c75'],
        height: 200
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_divCo230d'));
      chart.draw(data, options);
    }

</script>

<script>
  google.charts.setOnLoadCallback(drawTemperature24);
  //google.charts.setOnLoadCallback(drawTemperature24_indoor);
  google.charts.setOnLoadCallback(drawTemperature24_delta);
  google.charts.setOnLoadCallback(drawPressure24);
  google.charts.setOnLoadCallback(drawHumidity24);
  //google.charts.setOnLoadCallback(drawHumidity24_indoor);
  //google.charts.setOnLoadCallback(drawRainstate24);
  google.charts.setOnLoadCallback(drawCo224);

  google.charts.setOnLoadCallback(drawTemperature7d);
  //google.charts.setOnLoadCallback(drawTemperature7d_indoor);
  google.charts.setOnLoadCallback(drawdelta7d);
  google.charts.setOnLoadCallback(drawPressure7d);
  google.charts.setOnLoadCallback(drawHumidity7d);
  //google.charts.setOnLoadCallback(drawHumidity7d_indoor);
  //google.charts.setOnLoadCallback(drawRainstate7d);
  google.charts.setOnLoadCallback(drawCo27d);

  google.charts.setOnLoadCallback(drawTemperature30d);
  //google.charts.setOnLoadCallback(drawTemperature30d_indoor);
  google.charts.setOnLoadCallback(drawdelta30d);
  google.charts.setOnLoadCallback(drawPressure30d);
  google.charts.setOnLoadCallback(drawHumidity30d);
  //google.charts.setOnLoadCallback(drawHumidity30d_indoor);
  google.charts.setOnLoadCallback(drawRainstate30d);
  google.charts.setOnLoadCallback(drawCo230d);

</script>


</body>

</html>
