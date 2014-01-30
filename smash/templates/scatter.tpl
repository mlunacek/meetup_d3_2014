{%- if extend -%}{% extends "base.html" %}{% endif %}
{% block content %}
<style type="text/css">
.axis path,
.axis line {
  fill: none;
  stroke: #000;
  shape-rendering: crispEdges;
}

.dot {
  stroke: #000;
  opacity: 0.75;
}

div.tooltip{{id}} {   
  position: absolute;           
  /*text-align: center; */
  width: 150px;                  
  height: 50px;                 
  padding: 2px;             
  font: 12px sans-serif;        
  background: white;   
  border: 0px;      
  border-radius: 8px;           
  pointer-events: none;         
}

</style>
<div id="vis{{id}}"></div>
<script src="http://d3js.org/d3.v2.min.js"></script>
<script type="text/javascript">
var margin = {top: 20, right: 20, bottom: 30, left: 70},
    width = {{width}} - margin.left - margin.right,
    height = {{height}} - margin.top - margin.bottom;

var x = d3.scale.linear()
    .range([0, width]);

var y = d3.scale.linear()
    .range([height, 0]);


var color = d3.scale.category20c()

var xAxis = d3.svg.axis()
    .scale(x)
    .orient("bottom");

var yAxis = d3.svg.axis()
    .scale(y)
    .orient("left");

var div = d3.select("#vis{{id}}").append("div")   
    .attr("class", "tooltip{{id}}")               
    .style("opacity", 0);

var svg = d3.select("#vis{{id}}").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

data = {{data}};

  var u = {}, a = [];  
  data.forEach(function(d) {
    d['{{x}}'] = +d['{{x}}'];
    d['{{y}}'] = +d['{{y}}'];
    if( !u.hasOwnProperty(d['{{color}}'])) {
        a.push(d['{{color}}']);
        u[d['{{color}}']] = 1;
    }
  });

  // Remove nice to fit exactly in bounds

  x.domain(d3.extent(data, function(d) { return d['{{x}}']; })).nice();
  y.domain(d3.extent(data, function(d) { return d['{{y}}']; })).nice();

  console.log(a);
  var color = d3.scale.ordinal()
    .domain(a)
    .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);

  // // var color = d3.scale.category10();
  // var color = d3.scale.ordinal()
  //     .range(["#98abc5", "#8a89a6", "#7b6888", "#6b486b", "#a05d56", "#d0743c", "#ff8c00"]);

  // color.domain(a);
  // console.log(d3.scale.ordinal().domain().domain());

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)
    .append("text")
      .attr("class", "label")
      .attr("x", width)
      .attr("y", -6)
      .style("text-anchor", "end")
      .text("{{x}}");

  svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
    .append("text")
      .attr("class", "label")
      .attr("transform", "rotate(-90)")
      .attr("y", 6)
      .attr("dy", ".71em")
      .style("text-anchor", "end")
      .text("{{y}}")

  svg.selectAll(".dot")
      .data(data)
    .enter().append("circle")
      .attr("class", "dot")
      .attr("r", 5)
      .attr("cx", function(d) { return x(d['{{x}}']); })
      .attr("cy", function(d) { return y(d['{{y}}']); })
      .style("fill", function(d) { return color(d['{{color}}']); })
      .on("mouseover", function(d) {  
            //console.log(d3.event.pageX+','+d3.event.pageY);    
            div.transition()        
                .duration(200)      
                .style("opacity", .9);      
            div.html( 
             '{{x}}'+'=' + d['{{x}}'] + '<br/>' +
             '{{y}}' + '=' + d['{{y}}'] + '<br/>' +
             '{{color}}' +'=' + d['{{color}}']
              )  
                .style("left", (d3.event.pageX) + "px")     
                .style("top", (d3.event.pageY) + "px");    
            })                  
        .on("mouseout", function(d) {       
            div.transition()        
                .duration(500)      
                .style("opacity", 0);   
        });


  var legend = svg.selectAll(".legend")
      .data(color.domain())
    .enter().append("g")
      .attr("class", "legend")
      .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; });

  legend.append("rect")
      .attr("x", width - 18)
      .attr("width", 18)
      .attr("height", 18)
      .style("fill", color);

  legend.append("text")
      .attr("x", width - 24)
      .attr("y", 9)
      .attr("dy", ".35em")
      .style("text-anchor", "end")
      .text(function(d) { return d; });
</script>
{% endblock %}