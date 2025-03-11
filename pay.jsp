<%@page import="java.util.TimeZone"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.rossgroupinc.memberz.bp.payment.AuthenticationHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css" rel="stylesheet">	
<title>Single Amount Payment </title>
<style type="text/css">
p { margin-bottom: 5px;}
</style>
</head>
<body>
<%

Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("UTC"));
String utcTime =  "" + ((cal.getTimeInMillis() * 10000) + 621355968000000000L);  // current utc tme in ticks
String orderNumber = "1000"; // your order no
String totalAmount = "10.00"; // amount to be charged to user
String locationId = "129202"; // 013 branch
String method = "token"; // sale or token

AuthenticationHelper authenticationHelper = new AuthenticationHelper();
// generate the HMAC signature
String signature =  authenticationHelper.generateSignatureForSingleAmount(method,totalAmount, orderNumber, utcTime, locationId);

%>
<div class="container">
	<div class="row">
		<div class="col-md-12">		
			<div class="page-header">
		        <h1>Order Details</h1>	        
		      </div>
			<!-- button configuration -->
			<div>
				<h3>Order No : <%=orderNumber%> </h3>  							
				<h3>Total Amount : <%=totalAmount%></h3>  			
			</div>
			
			<button api_access_id="<%=AuthenticationHelper.API_ACCESS_ID%>" 
					method="<%=method%>" 
				    version_number="<%=AuthenticationHelper.VERSION_NO%>" 
				    location_id="<%=locationId%>"
				    hash_method="sha256"
				    utc_time="<%=utcTime%>" 
				    order_number="<%=orderNumber%>" 
				    signature="<%=signature%>"	    
				    callback="forteCallback" 
				    total_amount="<%=totalAmount%>"	
				    allowed_methods="eCheck"
				    save_token="true"
				    
				    billing_company_name_attr="hide"
				    billing_street_line1_attr="hide"
				    billing_street_line2_attr="hide"
				    billing_locality_attr="hide"
				    billing_region_attr="hide"
				    billing_postal_code_attr="hide"
				    billing_country_attr="hide"
				    billing_email_address_attr="hide"
				    billing_phone_number_attr="hide"
				    
				    		    
			  	  >Capture Bank Account Data</button>	
    
			    <br/>
			    
			    <!-- showing the callback result in the div -->
			    <div class="page-header">
		        	<h1>Callback Result</h1>	        
		      	</div>
			    <div id="callback-result">
			    	<div id="begin"></div><br/>
			    	<div id="complete"></div><br/>
			    	<div id="fail"></div><br/>
			    	<div id="error"></div><br/>
			    </div>			
		</div>
	</div>
</div>
	    

<!-- 
	Change the src below to point to the Sandbox or Production environments:
	SandBox : https://sandbox.forte.net/checkout/v1/js
	Production : https://checkout.forte.net/v1/js
 -->
<script type="text/javascript" src="https://sandbox.forte.net/checkout/v2/js"></script>

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script type="text/javascript">  
function forteCallback(data){
	
	var responseJsonData = eval(data);	
	var resultJson = JSON.parse(responseJsonData.data);	
	var html = "";
	
	// response data
	for (var key in resultJson) {
		html += "<p>" + key+ " : " + resultJson[key] + '</p>';
	}	
	
	if(resultJson.event == "success"){						
		// add your own logic like save to db
		$("#callback-result #complete").html(html);
		
	} else if(resultJson.event == "begin"){
		$("#callback-result #begin").html(html);
		// add your own logic like save to db
		
	} else if(resultJson.event == "failure"){	
		$("#callback-result #fail").html(html);
		// add your own logic like save to db
		
	} else if(resultJson.event == "error"){
		$("#callback-result #error").html(html);
		// add your own logic like save to db
	}
}
</script>
</body>
</html>