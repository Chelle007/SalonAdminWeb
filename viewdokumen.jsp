<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<%response.setHeader("Cache-Control","no-cache");//untuk refresh screen supaya tidak ambil dari cache
  response.setHeader("Pragma","no-cache");
  response.setHeader("Expires","01/01/1990");
%>
<HTML>
<HEAD>
<META name="GENERATOR" content="Microsoft FrontPage 4.0">
<META http-equiv="Content-Style-Type" content="text/css">

<%@ page import="com.ysoft.*, java.sql.*, javax.sql.*, javax.naming.*, java.util.Vector, java.util.Properties, java.util.Hashtable, java.util.Enumeration" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.Statement"%>

<%
/*@ page import="dori.jasper.engine.*"
@ page import="dori.jasper.engine.export.*"
@ page import="dori.jasper.engine.util.*" */

    //Don't cache this page
	response.addHeader("Expires", "-1");
	response.addHeader("Content-Expires","-1");

        Statement st = null;
        PreparedStatement preSql = null;
	ResultSet ReportResult = null;
	java.io.File jasperPrintFile = null;
	JasperPrint jasperPrint = null;
	String outputFileName = "";
	String sqlreport="";
	String outputPayslipLink = "";
	String currentDir = System.getProperty("user.dir");
    System.out.println(currentDir);
	String JPath = currentDir+"/../webapps/EstateAdmin/laporan/";
	String output = currentDir+"/../webapps/EstateAdmin/output/";
    String pathlog = currentDir+"/LogEstate.txt";
    PrintWriter logJob = new PrintWriter(new FileWriter(pathlog, true), true);
javax.servlet.http.HttpSession ses = request.getSession();   	       

            // Create a database connection
            com.ysoft.General gen = new com.ysoft.General();
            com.ysoft.General Gen = new com.ysoft.General();  
            com.ysoft.subgeneral sgen = new com.ysoft.subgeneral(); 
            java.util.Vector vk=(java.util.Vector)ses.getAttribute("User");
     	    com.ysoft.convertxml convert = new com.ysoft.convertxml();
      		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
          	java.sql.Connection conn = connMgr.getConnection("db2");
            String id = gen.gettable(request.getParameter("Y11")).trim();
            String trx = gen.gettable(request.getParameter("Y12")).trim();
            String jenis = gen.gettable(request.getParameter("Y13")).trim();
            Vector data=sgen.getDataQuery(conn,"VIEWDOKUMEN1",new String[]{id});//[EstateId] ,b.name,b.idno,b.Addr,[EstateAddr]   ,[realaddr],[LandSize]               			
            Vector dataht=sgen.getDataQuery(conn,"VIEWDOKUMEN2",new String[]{id,trx});
            String nama1=gen.gettable(data.get(1)).trim();
            String alamat1=gen.gettable(data.get(3)).trim();
            String ktp1=gen.gettable(data.get(2)).trim();
            String nama2=gen.gettable(dataht.get(15)).trim();
            String alamat2=gen.gettable(dataht.get(17)).trim();
            String ktp2=gen.gettable(dataht.get(16)).trim();
            String str=gen.gettable(dataht.get(2));
            String end=gen.gettable(dataht.get(3));
            String prd="";
            if(str.length()>0 && end.length()>0) prd=""+Math.round((gen.getInt(gen.getHYFFormat(end,"dd-MM-yyyy"))-gen.getInt(gen.getHYFFormat(str,"dd-MM-yyyy")))/30);
	      Map parameters = new HashMap();
	      /*parameters.put("ket",gen.gettable(data.get(4)).trim());
	      parameters.put("prd",prd);
	      parameters.put("str",str);
	      parameters.put("end",end);
	      parameters.put("Nama1",nama1);
	      parameters.put("Alamat1",alamat1);
	      parameters.put("Nama2",nama2);
	      parameters.put("Alamat2",alamat2);
	      parameters.put("Ktp1",ktp1);
          parameters.put("Ktp2",ktp2);
        */
          //String jp="Sewa.jasper";
          String jp="Blank_A4.jasper";
          if(jenis.equalsIgnoreCase("B") ||jenis.equalsIgnoreCase("K")){
            jp="Beli.jasper";
          }
          jasperPrintFile = new File(JPath +jp);
         // jasperPrint = JasperFillManager.fillReport(jasperPrintFile.getAbsolutePath(), parameters, conn);
            JasperPrint printer = JasperFillManager.fillReport(JPath +jp, parameters,conn);
            //generate kedalam file report.pdf
              	   
       	outputFileName = output +"Kontrak"+id+"_"+trx+".pdf";
       	      
       	net.sf.jasperreports.engine.JRExporter exporter = new JRPdfExporter();
          exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, outputFileName);
          exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
          exporter.exportReport();
        
        /*JasperReport jasperReport = (JasperReport) JRLoader.loadObject(inputStream);
        response.setContentType("application/x-pdf");
        response.setHeader("Content-disposition", "inline; filename=myReport.pdf");
        OutputStream outputStream = response.getOutputStream();
        
        JRPdfExporter exporter = new JRPdfExporter();
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, outputStream);
        exporter.exportReport();          
  	*/
  	    outputPayslipLink = "/EstateAdmin/output/Kontrak"+id+"_"+trx+".pdf";		
            JasperExportManager.exportReportToPdfFile(printer,outputPayslipLink);
      java.util.Vector vks=(java.util.Vector)ses.getAttribute("User");
          String msg=sgen.update(conn,"STSPRINT",new String[]{id,trx});
          msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{sgen.getUserId(vks),"STSPRINT",id+","+trx});          
          		
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>

<SCRIPT Language = "JavaScript" src="general.js"></SCRIPT>
<TITLE>Cetak Dokumen</TITLE>
<%
	
	if (ses.getAttribute("User") == null){//checking expired session
%>
	   <jsp:forward page="login.jsp"/>
<%
	}%>
                        
<script language="JavaScript" type="text/JavaScript">
    function jump (){
   		window.open("<%=outputPayslipLink%>","Cetak Dokumen","toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
  	}
</script>
</head>

	<body class="no-skin" onload="jump()">
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">

						<div class="page-header">
							<h1>
								Dokumen
							</h1>
						</div><!-- /.page-header -->
						<div class="row">
                            <a href="<%=outputPayslipLink%>">Dokumen</a>
                        </div>
                    </div>
                </div>
		   </div><!-- /.main-content -->

		<!-- basic scripts -->

		<!--[if !IE]> -->
		<script src="assets/js/jquery-2.1.4.min.js"></script>
	</body>
</html>
                            
