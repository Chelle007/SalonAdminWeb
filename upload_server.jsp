<%@ page import="jxl.*"%>
<%@ page import="java.io.*"%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
<title>3R Corporate</title>
<link href="image/3R.png" rel="icon">
		<meta name="description" content="Static &amp; Dynamic Tables" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

		<!-- bootstrap & fontawesome -->
		<link rel="stylesheet" href="assets/css/bootstrap.min.css" />
		<link rel="stylesheet" href="assets/font-awesome/4.5.0/css/font-awesome.min.css" />

		<!-- page specific plugin styles -->

		<!-- text fonts -->
		<link rel="stylesheet" href="assets/css/fonts.googleapis.com.css" />

		<!-- ace styles -->
		<link rel="stylesheet" href="assets/css/ace.min.css" class="ace-main-stylesheet" id="main-ace-style" />

		<!--[if lte IE 9]>
			<link rel="stylesheet" href="assets/css/ace-part2.min.css" class="ace-main-stylesheet" />
		<![endif]-->
		<link rel="stylesheet" href="assets/css/ace-skins.min.css" />
		<link rel="stylesheet" href="assets/css/ace-rtl.min.css" />

		<!--[if lte IE 9]>
		  <link rel="stylesheet" href="assets/css/ace-ie.min.css" />
		<![endif]-->

		<!-- inline styles related to this page -->

		<!-- ace settings handler -->
		<script src="assets/js/ace-extra.min.js"></script>

		<!-- HTML5shiv and Respond.js for IE8 to support HTML5 elements and media queries -->

		<!--[if lte IE 8]>
		<script src="assets/js/html5shiv.min.js"></script>
		<script src="assets/js/respond.min.js"></script>
		<![endif]-->
	</head>
<%
	javax.servlet.http.HttpSession ses = request.getSession();   
	if (ses.getAttribute("User") == null){//checking expired session
%>
	   <jsp:forward page="login.jsp"/>
<%
	}                    
        com.ysoft.General gen = new com.ysoft.General();
        com.ysoft.General Gen = new com.ysoft.General();  
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral(); 
        String tp=gen.gettable(request.getParameter("tp"));
 	    com.ysoft.convertxml convert = new com.ysoft.convertxml();
  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        java.io.PrintWriter log = new java.io.PrintWriter(new java.io.FileWriter(gen.getDataLogFileQuery(), true), true);
      	 com.ysoft.subgeneral queryclass = new com.ysoft.subgeneral();
         String msg="";
         if(tp.equalsIgnoreCase("UPLOADMOVE")){
            if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("upload")){
                String spath="C:/apache-tomcat-7.0.81/webapps/3R/document/";
                com.oreilly.servlet.multipart.DefaultFileRenamePolicy df=new com.oreilly.servlet.multipart.DefaultFileRenamePolicy();
            	com.oreilly.servlet.MultipartRequest multi = new com.oreilly.servlet.MultipartRequest(request, spath, 10*1024*1024,"ISO-8859-1", df);
                
      		    if(multi.getFile("Fi")!=null){
      			    java.io.File fi=multi.getFile("Fi");      		               
      			    if (fi.exists()){
                        String fl=fi.getName();
  	            		Workbook workbook = Workbook.getWorkbook(fi);
  	            		Sheet sheet = workbook.getSheet(0);
  	            		boolean next=true;
  	            		int row=0;
                        ConvertDetail:while(next){
				                row++;			                		
			                	try{
				                	try{
						                Cell cell1 = sheet.getCell(0, row);//
						                if(gen.gettable(cell1.getContents()).trim().length()==0) break;
				                	}catch(Exception ie){
				                		break;
				                	}
                                    //No	No Container	No BL	Code	Import	Feeder	Tyoe	Size	Consignee	Status	Discharged Time Date 

					                Cell contno = sheet.getCell(1, row);//
					                Cell bl = sheet.getCell(2, row);//
					                Cell code = sheet.getCell(3, row);//
					                Cell sts = sheet.getCell(4, row);//
					                Cell feed = sheet.getCell(5, row);//
					                Cell size = sheet.getCell(6, row);//
					                Cell type = sheet.getCell(7, row);//
					                Cell cosign = sheet.getCell(8, row);//
					                Cell disch = sheet.getCell(10, row);//
//System.out.println("contno="+contno.getContents()+",bl="+bl.getContents());      		                                     
                                    if(contno.getContents()!=null){
                                      if(contno.getContents().trim().length()==11){
                                          java.util.Vector exist=sgen.getDataQuery(conn,"MOVEMENTEXIST",new String[]{contno.getContents(),gen.getToday("dd-MM-yyyy")});
                                          if(exist.size()==0){
                                              String imp="";
                                              if(bl.getContents()!=null){
                                                if(bl.getContents().length()>1) imp=bl.getContents().substring(0,1);
                                              }
                                              String tps="";
                                              if(code.getContents().trim().endsWith("02")){
                                                tps="W";
                                              }
                                              if(code.getContents().trim().endsWith("01")){
                                                tps="B";
                                              }
                                              String co="";
                                              if(cosign.getContents()!=null){
                                                  java.util.Vector findcosig=sgen.getDataQuery(conn,"FINDCODEDESCNOER",new String[]{"CSN",cosign.getContents()});
                                                  if(findcosig.size()==0){
                                                      java.util.Vector mcosig=sgen.getDataQuery(conn,"CODECOSIGNEEMAX",new String[0]);
                                                      String maxc=""+(gen.getInt(gen.gettable(mcosig.get(0)).trim().substring(2))+1);
                                                      if(maxc.length()==2){
                                                          co="CO0"+maxc;
                                                      }else if(maxc.length()==1){
                                                          co="CO00"+maxc;
                                                      }
                                                      
                                                      msg=sgen.update(conn,"COSIGNEEADD",new String[]{cosign.getContents(),"M",co});//insert ke cosignee
                                                  }else{
                                                    co=gen.gettable(findcosig.get(0)).trim();
                                                  }
                                              }                   
          		                              String di="";
                                              if(disch.getContents()!=null){
                                                if(disch.getContents().length()>0) di=gen.getFormatdate("dd-MM-yyyy",disch.getContents());
                                              }      
  //                                              System.out.println("insert into contno="+contno.getContents()+",bl="+bl.getContents()+",co="+co+","+di);
                                              //TrxDate,MOVEID,ContNo,[BLNo],[tpContainer],[Status],[feeder],[Size] ,[TypeCode] ,[Cosignee],[DischDate]                 
                                              String[] cd=new String[]{gen.getToday("dd-MM-yyyy"),"1",contno.getContents(),bl.getContents(),tps,sts.getContents(),feed.getContents(),size.getContents(),type.getContents(),co,di,imp};
                                              msg=sgen.update(conn,"UPLOADMOVEADD",cd);
                                          }
                                      }else{
                                        continue;
                                      }
                                    }else{
                                      continue;
                                    }
			                	}catch(Exception ie){
			                		ie.printStackTrace();
			                		break;
			                	}
                        }
                        //TrfDate,FileName,Filetp,FileSize,UserId,Parm
                        msg=sgen.update(conn,"UPLOADADD",new String[]{fl,"M",gen.getformatlong(fi.length() / 1000L),gen.gettable(ses.getAttribute("User")),""});
                        msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),"UPLOADMOVE",""});
                        msg="(File was Uploaded)";
      			    }
                }
              }
          }
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin" >
        <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1>Upload File <%=msg%></h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
									<div id="user-profile-3" class="user-profile row">
                                        <form name = "BGA" action="upload.jsp?tp=<%=tp%>&act=upload" method="post"  ENCTYPE="multipart/form-data">
                                        <div class="col-sm-offset-1 col-sm-10">
                                            <label class="control-label">File in xls format:</label>
                                            <label class="control-label">&nbsp;<input type="file" name="Fi" size="40" id="Fi"  tabindex="1" maxlength="60" value="<%=Gen.gettable(request.getParameter("Fi"))%>"  ></label>
                                            <label class="control-label">&nbsp;<input type="submit" value="Upload" name="act"> </label>
                                        </div>
                                       </form>
                                 </div>
                            </div>
                      </div>
					</div><!-- /.page-content -->
				</div>
			</div><!-- /.main-content -->

        <jsp:include page="footer.jsp" flush ="true"/>
		<!-- basic scripts -->

		<!--[if !IE]> -->
		<script src="assets/js/jquery-2.1.4.min.js"></script>

		<!-- <![endif]-->

		<!--[if IE]>
<script src="assets/js/jquery-1.11.3.min.js"></script>
<![endif]-->
		<script type="text/javascript">
			if('ontouchstart' in document.documentElement) document.write("<script src='assets/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>
		<script src="assets/js/bootstrap.min.js"></script>

		<!-- page specific plugin scripts -->
		<script src="assets/js/jquery.dataTables.min.js"></script>
		<script src="assets/js/jquery.dataTables.bootstrap.min.js"></script>
		<script src="assets/js/dataTables.buttons.min.js"></script>
		<script src="assets/js/buttons.flash.min.js"></script>
		<script src="assets/js/buttons.html5.min.js"></script>
		<script src="assets/js/buttons.print.min.js"></script>
		<script src="assets/js/buttons.colVis.min.js"></script>
		<script src="assets/js/dataTables.select.min.js"></script>

		<!-- ace scripts -->
		<script src="assets/js/ace-elements.min.js"></script>
		<script src="assets/js/ace.min.js"></script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
			jQuery(function($) {
				var active_class = 'active';
				$('#simple-table > thead > tr > th input[type=checkbox]').eq(0).on('click', function(){
					var th_checked = this.checked;//checkbox inside "TH" table header
					
					$(this).closest('table').find('tbody > tr').each(function(){
						var row = this;
						if(th_checked) $(row).addClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', true);
						else $(row).removeClass(active_class).find('input[type=checkbox]').eq(0).prop('checked', false);
					});
				});
				
				//select/deselect a row when the checkbox is checked/unchecked
				$('#simple-table').on('click', 'td input[type=checkbox]' , function(){
					var $row = $(this).closest('tr');
					if($row.is('.detail-row ')) return;
					if(this.checked) $row.addClass(active_class);
					else $row.removeClass(active_class);
				});
			
				
			
				/********************************/
				//add tooltip for small view action buttons in dropdown menu
				$('[data-rel="tooltip"]').tooltip({placement: tooltip_placement});
				
				//tooltip placement on right or left
				function tooltip_placement(context, source) {
					var $source = $(source);
					var $parent = $source.closest('table')
					var off1 = $parent.offset();
					var w1 = $parent.width();
			
					var off2 = $source.offset();
					//var w2 = $source.width();
			
					if( parseInt(off2.left) < parseInt(off1.left) + parseInt(w1 / 2) ) return 'right';
					return 'left';
				}
				
				
				
				
				/***************/
				$('.show-details-btn').on('click', function(e) {
					e.preventDefault();
					$(this).closest('tr').next().toggleClass('open');
					$(this).find(ace.vars['.icon']).toggleClass('fa-angle-double-down').toggleClass('fa-angle-double-up');
				});
				/***************/
				
				
				
				
				
				/**
				//add horizontal scrollbars to a simple table
				$('#simple-table').css({'width':'2000px', 'max-width': 'none'}).wrap('<div style="width: 1000px;" />').parent().ace_scroll(
				  {
					horizontal: true,
					styleClass: 'scroll-top scroll-dark scroll-visible',//show the scrollbars on top(default is bottom)
					size: 2000,
					mouseWheelLock: true
				  }
				).css('padding-top', '12px');
				*/
			
			
			})
         	function closed(){
        		window.close();
        	}
		</script>
	</body>
</html>
