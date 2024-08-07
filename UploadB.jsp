<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%@ taglib uri="/TitleContent" prefix="Transform" %>
<html>
<head>
<title>Upload File</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<%
		javax.servlet.http.HttpSession ses = request.getSession();   
		if (ses.getAttribute("TxtEmployee") == null){
%>
	<jsp:forward page="../general/MustLogin.html"/>
<%
	}
        String fron = "http://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
        com.service.addition.General Gen = new com.service.addition.General(); 
		String view="disabled",isok="0";
		if (Gen.gettable(request.getParameter("canadd")).equalsIgnoreCase("1") ){
				view="";
				isok="1";
		}
		String title="",type="";
	 	String TPS=Gen.gettable(request.getParameter("Type"));
		String url="../general/forwardurl.jsp?Type="+TPS+"&Y11="+Gen.gettable(request.getParameter("Y11"))+"&link="+request.getRequestURI();
		if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("TS")){
			 title="Upload Timesheet";
			 type="UPLOAD1";
		}else if  (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("AT")){
			 title="Upload Time Attendance";
			 type="UPLATTD1";
		}else if  (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EE")){
			 title="Upload Employee";
			 type="UPLEE1";
		}else if  (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("MC")){
			 title="Upload Medical Claim";
			 type="UPLMED1";
		}else if  (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("RT")){
			 title="Upload Roster";
			 type="UPLROSTER1";
		}else if  (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("SC")){
			 title="Upload Salary Change";
			 type="UPLSALCHG1";
		}else if  (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EP")){
			 title="Upload Employee Payment";
			 type="UPLEPY1";
		}else if  (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("OTE")){
			 title="Upload Overtime Extended";
			 type="UPLOTE1";
		}else if  (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("MOE")){
			 title="Upload Multi Cycle OT Extended";
			 type="UPLMCOTE1";
		}else if  (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("DOE")){
			 title="Upload Document Employee";
			 type="UPLDOCEE1";
		}else if  (Gen.gettable(request.getParameter("Type")).startsWith("EEDOCLIST")){
			title="Upload Document Employee";
			type="EEDOCLISTNEXT";
			url="../Statement?Type="+type+"&Y11="+Gen.gettable(request.getParameter("Y11"))+"&link="+request.getRequestURI();
		}else if  (Gen.gettable(request.getParameter("Type")).startsWith("APPLDOCLIST")){
			title="Upload Document Applicant";
			type="APPLDOCLISTNEXT";
			url="../Statement?Type="+type+"&Y11="+Gen.gettable(request.getParameter("Y11"))+"&link="+request.getRequestURI();
		}else if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EFAM")){
			 title="Upload Employee Family";
			 type="UPLEEFAM1";
		}else if  (Gen.gettable(request.getParameter("ts")).startsWith("BTL")){
			title="Upload Document Employee";
			type="EEDOCLISTNEXT";
			url="../Statement?Type="+type+"&ee="+Gen.gettable(request.getParameter("ee"))+"&ts="+Gen.gettable(request.getParameter("ts"))+"&Y11="+Gen.gettable(request.getParameter("Y11"))+"&tb="+Gen.gettable(request.getParameter("tb"))+"&Y12="+Gen.gettable(request.getParameter("Y12"))+"&link="+request.getRequestURI();
		}else if  (Gen.gettable(request.getParameter("ts")).startsWith("LOAN")){
			title="Upload Document Employee Loan";
			type="EEDOCLISTNEXT";
			url="../Statement?Type="+type+"&ts="+Gen.gettable(request.getParameter("ts"))+"&Y11="+Gen.gettable(request.getParameter("Y11"))+"&Y12="+Gen.gettable(request.getParameter("Type"))+"&link="+request.getRequestURI();
		}else if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EEDU")){
			 title="Upload Employee Education";
			 type="UPLEEEDU1";
		}else if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EPRE")){
			 title="Upload Previous Employment";
			 type="UPLEEPREV1";
		}else if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EPOS")){
			 title="Upload Plain Position Change";
			 type="UPLEEPOS1";
		}else if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EIBD")){
			 title="Upload Income By Date";
			 type="UPLINCBYDT1";
		}else if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EDBD")){
			 title="Upload Deduction By Date";
			 type="UPLDEDBYDT1";
		}else if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EGRD")){
			 title="Upload Grade and Salary Change";
			 type="UPLEEGRD1";
		}else if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("ERTS")){
			 title="Upload Multi Employer Timesheet";
			 type="UPLEEMERTS1";
		}else if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("PMSG")){
			 title="Upload Pay Message";
			 type="UPLPMSG1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("CD")){
		 	title="Upload Code";
			type="UPLCD1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("LV")){
		 	title="Upload Level";
			type="UPLLVL1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("LO")){
		 	title="Upload Location";
			type="UPLLOC1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("SR")){
		 	title="Upload Salary Range";
			type="UPLSR1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("RG")){
		 	title="Upload Role Group X-ref";
			type="UPLRG1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("GR")){
		 	title="Upload Grade";
			type="UPLGRD1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("PS")){
		 	title="Upload Position";
			type="UPLPOS1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("PC")){
		 	title="Upload PayCycle";
			type="UPLPC1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("DE")){
		 	title="Upload Deduction";
			type="UPLDED1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("IN")){
		 	title="Upload Income";
			type="UPLIN1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EP")){
		 	title="Upload Employee Payment";
			type="UPLEP1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EL")){
		 	title="Upload Employee License";
			type="UPLEL1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EES")){
		 	title="Upload Employee Seniority";
			type="UPLEES1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("OTRSR")){
		 	title="Upload Overtime Request Sari Roti"; 
			type="UPLOTSR1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EGV")){
		 	title="Upload Grade Variable";
			type="UPLEGV1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EOE")){
		 	title="Upload End OF Employment";
			type="UPLEOE1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("VRA")){
		 	title="Upload Variable Allowance";
			type="UPLVRA1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("EN")){
		 	title="Upload Employee Number";
			type="UPLEN1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("AFG")){
		 	title="Upload Appraisal Factor";
			type="UPLAF1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("ATN")){
		 	title="Upload Attendance";
			type="UPLATN1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("AFC")){
		 	title="Upload Appraisal Factor";
			type="UPLAFC1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("ERTB")){
		 	title="Upload Employee Training Budget";
			type="UPLERTB1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("WSC")){
		 	title="Upload Work Schedule Change";
			type="UPLWRKSCH1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("SAPJ")){
		 	title="Upload SAP Journal";
			type="UPLSAPJ1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("BDDT")){
		 	title="Upload Additional Budget Detail"; 
			type="UPLBDDT1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("OVT")){
		 	title="Upload Overtime"; 
			type="UPLOVT1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("FSSI")){
		 	title="Upload Attendance Income FSSI"; 
			type="UPLFSI1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("ATSRN")){
		 	title="Upload Attendance Sari Roti (New)"; 
			type="UPLSRN1";
		}else	if (Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("INCTV")){
		 	title="Upload Incentive"; 
			type="UPLINCTV1";
		}	
		String ts=type;
		if(Gen.gettable(request.getParameter("ts")).length()>0) ts=Gen.gettable(request.getParameter("ts"));
		url=url+"&ts="+ts;
%>
<SCRIPT Language = "JavaScript" src="../general/general.js"></SCRIPT>
<script language="JavaScript" src="../other/other_scripts.js"></script>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
	function closed(){
	   <%if(Gen.gettable(request.getParameter("ts")).startsWith("EPA")){%>
	      window.opener.document.BGA.TD.value="<%=Gen.gettable(request.getParameter("tp"))%>";
	   <%}else if(Gen.gettable(request.getParameter("ts")).startsWith("LOAN")){%>
	      window.opener.document.BGA.ST1.value="<%=Gen.gettable(request.getParameter("tp"))%>";
	   <%}else if(Gen.gettable(request.getParameter("ts")).startsWith("TRC")||Gen.gettable(request.getParameter("ts")).startsWith("BTL")){%>
	      window.opener.document.BGA.<%=Gen.gettable(request.getParameter("Y11"))%>.value="<%=Gen.gettable(request.getParameter("tp"))%>";
	   <%}else{%>
	      window.opener.document.BGA.T1.value="<%=Gen.gettable(request.getParameter("tp"))%>";
	      window.opener.document.BGA.T2.value="<%=Gen.gettable(request.getParameter("tpd"))%>";
	   <%}%>
		window.close();
	}
	function setLink(){
		document.BGA.action.value="Change";
		BGA.submit();
	}
	function SetFieldNoArray(Parm1,Parm2){
		Parm1.value=Parm2;
	}
</script>
</head>

<body bgcolor="#EFF3EF" leftmargin="0" topmargin="0" marginwidth="0" marginweight="0" <%if(!Gen.gettable(request.getParameter("onload")).equalsIgnoreCase("false")){%>onload="LoadFrameButton('<%=Gen.gettable(request.getParameter("Type"))%>B&isok=<%=isok%>')"<%}else if (Gen.gettable(request.getParameter("close")).equalsIgnoreCase("true")){%>onload="closed()"<%}%>>
<script language="JavaScript1.2" src="../frames/cframe.js" type="text/javascript"></script>
<div id="Layer2" style="position:absolute; width:190; height:70; z-index:2; top: 15; left: 570;"><img src="../imgs/content/logo_transform.gif" name="logo" width="190" height="70" id="logo"></div>
<p>&nbsp;</p>
<Transform:Title title="<%=title%>"></Transform:Title>
<form name = "BGA" action="<%=url%>" method="post"  ENCTYPE="multipart/form-data">
 <jsp:include page="../general/errmessage.jsp" flush ="true"/>
<table width="95%" align="center" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td width="25%" align="right"> <font  face="Verdana, Arial, Helvetica, sans-serif" size="2">*File :</font></td>
      <td><font  face="Verdana, Arial, Helvetica, sans-serif" size="2"><b>
		<input type="file" name="Pict" size="40" id="Pict"  tabindex="1" maxlength="60" value="<%=Gen.gettable(request.getParameter("Pict"))%>"  >&nbsp;&nbsp;&nbsp;
<%if  (Gen.gettable(request.getParameter("Type")).startsWith("EEDOCLIST") || Gen.gettable(request.getParameter("Type")).startsWith("APPLDOCLIST")){%>
			<input type="button" value="OK" name="act" style="font-weight: bold" onclick="setLink()"></font> 
<%}%>
        </b>
        </font>
      </td>
    </tr>
    <tr>
    <td width="25%" align="right" > <font  face="Verdana, Arial, Helvetica, sans-serif" size="2">*File Description:</font></td>
      <td ><font  face="Verdana, Arial, Helvetica, sans-serif" size="2"><b><input type="text" name="Y12" size="60" tabindex="2" maxlength="100"  value="<%=Gen.gettable(request.getParameter("Y12"))%>">&nbsp;&nbsp;&nbsp; </b>
        </font>
      </td>
    </tr>
<%if  (!Gen.gettable(request.getParameter("Y11")).equalsIgnoreCase("DOE") && !Gen.gettable(request.getParameter("Type")).startsWith("EEDOCLIST") && !Gen.gettable(request.getParameter("Type")).startsWith("APPLDOCLIST")){
%>
    <tr>
    <td width="25%"  align="right"> <font  face="Verdana, Arial, Helvetica, sans-serif" size="2">*File Type :</font></td>
      <td ><font  face="Verdana, Arial, Helvetica, sans-serif" size="2">
		  <input type="hidden" name="filetype"  value = "<%if (request.getParameter("filetype")==null) out.print("csv");else out.print(Gen.gettable(request.getParameter("filetype")));%>">
          <select size="1" name="status"  onchange="SetFieldNoArray(filetype, status.options[status.selectedIndex].text)"  >
            <option <%if (Gen.gettable(request.getParameter("filetype")).trim().equalsIgnoreCase("csv")) out.print("selected");%>>csv</option>
            <option <%if (Gen.gettable(request.getParameter("filetype")).trim().equalsIgnoreCase("txt")) out.print("selected");%>>txt</option>
            <option <%if (Gen.gettable(request.getParameter("filetype")).trim().equalsIgnoreCase("xls")) out.print("selected");%>>xls</option>
          </select>
        </font>
      </td>
    </tr>
<%}
%>
  </table> 
  <input type="hidden" name="tp" value = "<%=Gen.gettable(request.getParameter("tp"))%>">
  <input type="hidden" name="fieldkey" value = "<%=Gen.gettable(request.getParameter("fieldkey"))%>">
  <input type="hidden" name="ts" value = "<%=ts%>">
  <input type="hidden" name="add" value = "true">
<jsp:include page="../general/hiddenfieldC.jsp" flush ="true"/>
</form>
</body>
</html>
