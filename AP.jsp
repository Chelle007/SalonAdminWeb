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
        

         String[] judul=new String[]{"VENDOR","DESCRIPTION","CUR","AMOUNT","PAID AMOUNT","END BALANCE"};
         
          String title="Account Payable";       
          String[] cond=new String[0];
            
            String y11=gen.gettable(request.getParameter("Y11"));
            String y10=gen.gettable(request.getParameter("Y10"));
            if(request.getParameter("Y11")==null ||y11.length()==0){
                java.util.Vector userdef=sgen.getDataQuery(conn,"USERDEF",new String[]{gen.gettable(ses.getAttribute("TxtErcode"))});
                if(userdef.size()>0){
                    y11=gen.gettable(userdef.get(1));//gen.getToday("yyyy");
                    y10="1";//gen.getInt(gen.getToday("MM"))+"";                                
                }
//                    y11="2021";//gen.getToday("yyyy");
  //                  y10="1";//gen.getInt(gen.getToday("MM"))+"";                                
            }
            int mth=gen.getInt(y10);
            String f3=gen.gettable(request.getParameter("Y12"));
            String tpx=tp;
            String ket="";
            if(gen.gettable(request.getParameter("Y14")).equalsIgnoreCase("O")){
                tpx="APOUTSTANDING";
            }else if(gen.gettable(request.getParameter("Y14")).equalsIgnoreCase("V")){
                tpx="AP";            
            }else if(gen.gettable(request.getParameter("Y14")).equalsIgnoreCase("")){
                tpx="APALL";            
            }
            java.util.Vector data=sgen.getDataQuery(conn,tpx,new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y10,y11,y11,gen.gettable(ses.getAttribute("TxtErcode"))});
            java.util.Vector tmp=new java.util.Vector();
            for(int m=0;m<data.size();m+=5){
                if(gen.gettable(request.getParameter("Y13")).length()>0 && !gen.gettable(request.getParameter("Y13")).equalsIgnoreCase(gen.gettable(data.get(m+2)).trim())){
                    continue;
                }
                if(f3.length()==0 || f3.equalsIgnoreCase(gen.gettable(data.get(m)).trim())){
                    String bal="0";
                    String endbal=""+(gen.getformatdouble(data.get(m+3))-gen.getformatdouble(data.get(m+4)));
                  //  if(gen.getformatdouble(endbal)!=0){
                      tmp.addElement(data.get(m));
                      tmp.addElement(data.get(m+1));
                      tmp.addElement(data.get(m+2));
                      tmp.addElement(data.get(m+3));
                      tmp.addElement(data.get(m+4));
                      tmp.addElement(endbal);
                    //}                             
                }
            }
            data=tmp;
            if(gen.gettable(request.getParameter("tpx")).equalsIgnoreCase("Download")){
                  com.ysoft.BUILDEXCEL bd=new com.ysoft.BUILDEXCEL();
                  if(gen.gettable(request.getParameter("tx")).equalsIgnoreCase("1")){
                    java.util.Vector judulx=new java.util.Vector();
                    for(int mt=0;mt<judul.length;mt++) judulx.addElement(judul[mt]);//gen.getElement(',',"[tpContainer],[ContNo] ,[BLNo],[Status],[feeder],[TypeCode] ,[Cosignee],[Cosignee Name],[STS],[DischDate] ,[CosigPickDate],[ReturnInDepotDate] ,[Remark],[Doc],[Shipper],[Shipper Name],[Status2],[GetOutDate] ,[GetInPortDate],[LoadOnFeederDate] ,[vsl],[EtdBtmDate],[EtaSinDate],[SealNo],[BLNO2],[DM],[ExpBL],[ExpCode] ,[ExpDept] ,[ExpTrade] ,[ImpBL] ,[ImpCode],[ImpDept],[ImpTrade],[Service],[POD],");                  
                    java.util.Vector datax=sgen.getDataQuery(conn,"APEXCEL1",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y11,gen.gettable(ses.getAttribute("TxtErcode"))});
                    for(int s=0;s<datax.size();s+=6){
                        double b=gen.getformatdouble(datax.get(s+3))-gen.getformatdouble(datax.get(s+4));
                        datax.setElementAt(b+"",s+5);
                    }
                    ses.setAttribute("DATAXLS",datax);
                    ses.setAttribute("JUDULXLS",judulx);
                    java.util.Vector jdx=new java.util.Vector();
                    for(int mt=0;mt<judul.length;mt++){
                      if(mt<3) jdx.addElement("0"); else jdx.addElement("2");
                    }
                    ses.setAttribute("NUMBERXLS",jdx);
                  }else{
                    String tpx1=tp+"EXCEL";
                    java.util.Vector maxmth=sgen.getDataQuery(conn,"AREXCELMAX",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11});      
                    java.util.Vector judulx=gen.getElement(',',"VENDOR CODE,VENDOR DESCRIPTION,CURR,"+y11+",");
                    String month[]=new String[]{"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
                    java.util.Vector jdx=new java.util.Vector();
                    int mtt=1;
                    if(maxmth.size()>0)mtt=gen.getInt(maxmth.get(0));
             //       System.out.println("mtt="+mtt);
                    for(int mt=1;mt<=mtt;mt++){
                      judulx.addElement(month[mt-1]+"-"+y11);
                    } 
                    for(int mt=0;mt<judulx.size();mt++){
                      if(mt<3) jdx.addElement("0"); else jdx.addElement("2");
                    }
                    
                    
                    java.util.Vector datah=sgen.getDataQuery(conn,tpx1+"1",new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y11,gen.gettable(ses.getAttribute("TxtErcode"))});
                    java.util.Vector datax=sgen.getDataQuery(conn,tpx1,new String[]{gen.gettable(ses.getAttribute("TxtErcode")),y11,y11,gen.gettable(ses.getAttribute("TxtErcode"))});
                    java.util.Vector ttdata=new java.util.Vector();
                    for(int x=0;x<datah.size();x+=6){
                      ttdata.addElement(datah.get(x));
                      ttdata.addElement(gen.gettable(datah.get(x+1)).trim());
                      ttdata.addElement(gen.gettable(datah.get(x+2)).trim());
                      ttdata.addElement(gen.gettable(datah.get(x+3)).trim());
                      for(int xxx=1;xxx<=mtt;xxx++){
                          String ct="0";
                          for(int xx=0;xx<datax.size();xx+=5){
                              if(gen.gettable(datax.get(xx)).trim().equalsIgnoreCase(gen.gettable(datah.get(x)).trim()) && gen.gettable(datax.get(xx+1)).trim().equalsIgnoreCase(gen.gettable(datah.get(x+2)).trim()) && gen.getInt(datax.get(xx+3))==xxx){
                                  ct=gen.gettable(datax.get(xx+2));
                              }
                          }
                          ttdata.addElement(ct);
                      }
                    }
                    ses.setAttribute("NUMBERXLS",jdx);
                    ses.setAttribute("DATAXLS",ttdata);
                    ses.setAttribute("JUDULXLS",judulx);
                }
                  bd.doAll(request);
            }            
            
        //System.out.println(tpx+","+f3+","+gen.gettable(request.getParameter("Y14")));
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin" <%if(gen.gettable(request.getParameter("tpx")).startsWith("Download")){%> onload="pop()"<%}%>>
    <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1><%=title%> <%=msg%>&nbsp;&nbsp;&nbsp;<a href="javascript:down('1')"><img width=30 height=30 src=image/download.jfif ></a></h1>
						</div><!-- /.page-header -->
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div id="user-profile-3" class="user-profile row">
                                        <div class="col-sm-offset-1 col-sm-10">
                						<form class="form-horizontal" name="BGA" method="POST" action="AP.jsp?tp=<%=tp%>" >
                                            <label class="control-label">&nbsp;Curr:<select name="Y13" onchange="refresh();"> <option></option><option value="IDR" <%if(Gen.gettable(request.getParameter("Y13")).trim().equalsIgnoreCase("IDR")) out.print("selected");%>>IDR</option>
                                            <option value="USD" <%if(Gen.gettable(request.getParameter("Y13")).trim().equalsIgnoreCase("USD")) out.print("selected");%>>USD</option>
                                                                  	<option value="SGD" <%if(Gen.gettable(request.getParameter("Y13")).trim().equalsIgnoreCase("SGD")) out.print("selected");%>>SGD</option>
                                                                  	<option value="CNY" <%if(Gen.gettable(request.getParameter("Y13")).trim().equalsIgnoreCase("CNY")) out.print("selected");%>>CNY</option>
                                                                  	<option value="EUR" <%if(Gen.gettable(request.getParameter("Y13")).trim().equalsIgnoreCase("EUR")) out.print("selected");%>>EUR</option></select>
                                            <input type="hidden" name="Y10" size="2" maxlength="2" value="<%=y10%>"  onchange="refresh();"><input type="hidden" name="Y11" size="4" maxlength="4" value="<%=y11%>"  onchange="refresh();">                                                                                                                  
                                            </label>                                                                
                                            <label class="control-label">&nbsp;Status AP:<select name="Y14" onchange="refresh();">
                                            <option></option>
                                            <option value="O" <%if(Gen.gettable(request.getParameter("Y14")).trim().equalsIgnoreCase("O")) out.print("selected");%>>Outstanding</option>            
                                            <option value="V" <%if(Gen.gettable(request.getParameter("Y14")).trim().equalsIgnoreCase("V")) out.print("selected");%>>Validated</option>
                                            </select> </label>                                                                
										    <label class="control-label">&nbsp;&nbsp;*Vendor:
                                                    <input type="text" name="Y12" size="5" maxlength="7" value="<%=Gen.gettable(request.getParameter("Y12"))%>"  onchange="refresh();">
                                                    <input type="text" name="SY6" size="25" maxlength="60"  value="<%=Gen.gettable(request.getParameter("SY6")).trim()%>" disabled>
                                                    <input type="button" value="..." name="act1" style="font-weight: bold" onClick="setLink('VENDOR','Y12','SY6','<%=gen.gettable(ses.getAttribute("TxtErcode"))%>,','')">
                                             </label>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:down('2')">Unpaid AP</a>
                                                <input type="hidden" name="tpx" value="">
                                                <input type="hidden" name="tx" value="">
                                                <input type="hidden" name="tb" value="<%=title%>">
                                          </form>
                                    </div>
                                 </div>
                               </div>
                             </div>
                          </div>

						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
										<table id="simple-table" class="table  table-bordered table-hover">
											<thead>
												<tr>													
                                                        <%for(int s=0;s<judul.length;s++){
                                                            if(judul[s].length()==0)continue;
                                                        %>         
														<th><%=judul[s]%>&nbsp;</th>
                                                        <%}%>                                                        
    											</tr>
											</thead>

											<tbody>
                                                   <%
                                                   int hic=1;
                                                   double gtot=0;
                                                   for(int s=0;s<data.size();s+=judul.length){%>         
												<tr>
                                                       <%
                                                       gtot+=gen.getformatdouble(data.get(s+5));
                                                       for(int ss=0;ss<judul.length;ss++){
                                                            if(judul[ss].length()==0)continue;
                                                       %>
                                                            <td <%if(ss>2) out.print("align=right");%>>
                                                            <%if(ss==0){%>
                                                            <a href="APDetail.jsp?tp=APDETAIL&canedit=true&Y10=<%=y10%>&Y11=<%=y11%>&Y12=<%=Gen.gettable(request.getParameter("Y12"))%>&Y14=<%=Gen.gettable(request.getParameter("Y14"))%>&S1=<%=gen.gettable(data.get(s)).trim()%>&S2=<%=gen.gettable(data.get(s+1)).trim()%>&S3=<%=gen.gettable(data.get(s+5)).trim()%>&S4=<%=gen.gettable(data.get(s+2)).trim()%>"><%=gen.gettable(data.get(s+ss)).trim()%></a>
                                                            <%}else{
                                                                if(ss<=2){
                                                                 out.print(gen.gettable(data.get(s+ss)).trim());
                                                                }else{
                                                                 out.print(gen.getNumberFormat(data.get(s+ss),2));
                                                                }
                                                            %>
                                                            
                                                            <%}%>
                                                            </td>
                                                        <%}%>
												</tr>
                                                <%}%>
                                                <%if(gen.gettable(request.getParameter("Y13")).length()!=0){%><tr><td colspan=6 align=right><b>TOTAL:&nbsp;&nbsp;<%=gen.getNumberFormat(gtot+"",2)%></td></tr><%}%>
											</tbody>
										</table>
								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->
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
            function down(parm){
                document.BGA.tpx.value="Download";
                document.BGA.tx.value=parm;
                BGA.submit();
            }
        	function pop (){
        		window.open("download/<%=gen.gettable(request.getParameter("tb"))%>.xls","","toolbar=yes,menubar=yes,resizable=1,scrollbars=1");
        	}
            function  refresh(){
                    document.BGA.SY6.disabled=false;
                      BGA.submit();
            }
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
            
            
		</script>
	</body>
</html>
