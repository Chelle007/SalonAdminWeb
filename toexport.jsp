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
         String title="Movement to Export";       

        if(Gen.gettable(request.getParameter("act")).equalsIgnoreCase("Save")){
        //Status2=?,Shipper=?,Vsl=?,SealNo=?,[GetOut]=?
                msg=sgen.update(conn,tp,new String[]{Gen.gettable(request.getParameter("T5")),Gen.gettable(request.getParameter("T3")),Gen.gettable(request.getParameter("T1")),Gen.gettable(request.getParameter("T2")),Gen.gettable(request.getParameter("T4")),Gen.gettable(request.getParameter("T6")),Gen.gettable(request.getParameter("S3")),Gen.gettable(request.getParameter("S1"))});
                msg=sgen.update(conn,"LOGMENUPARMADD",new String[]{gen.gettable(ses.getAttribute("User")),tp,gen.gettable(request.getParameter("S3"))+"|"+Gen.gettable(request.getParameter("S1"))+"|"});
                if(msg.length()>0){
                    msg="(Update Data Failed!!"+msg+")";
                }else{
                    msg="(Update Data Successfully)";
                }
     
                //System.out.println(tp+Gen.gettable(request.getParameter("act")));
        }
        
        String[] judul=new String[]{"DATE","","CONT NO.","BL NO","TP","SIZE","TYPE","RETURN IN DEPOT DATE"};
          java.util.Vector status2=sgen.getDataQuery(conn,"STATUS2",new String[0]);
        java.util.Vector data=sgen.getDataQuery(conn,tp,new String[0]);
       // System.out.println("job>>"+data.size()+","+f1+","+f2+",tpx="+tpx);     
          connMgr.freeConnection("db2", conn);
          connMgr.release();
%>


	<body class="no-skin" >
            <jsp:include page="menu.jsp" flush ="true"/>
			<div class="main-content">
				<div class="main-content-inner">
					<div class="page-content">
						<div class="page-header">
							<h1><%=title%> <%=msg%></h1>
						</div><!-- /.page-header -->
                        <form class="form-horizontal" name="BGA" method="POST" action="toexport.jsp?tp=<%=tp%>" >
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div>
									<div id="user-profile-3" class="user-profile row">
                                        
                                            <label class="control-label">&nbsp;&nbsp;&nbsp;*Export:
                                                <select name="T5" >
                                                  <option></option>
                                                  <%for(int m=0;m<status2.size();m+=1){%>
                                              	<option value="<%=gen.gettable(status2.get(m))%>" <%if(Gen.gettable(request.getParameter("T5")).trim().equalsIgnoreCase(gen.gettable(status2.get(m)).trim())) out.print("selected");%>><%=gen.gettable(status2.get(m)).trim()%></option>
                                                  <%}%>
                                                  </select>
                                            </label>                        
                                            <label class="control-label">&nbsp;*Shipper:
                          		              <input type="hidden" name="T3" value="<%=Gen.gettable(request.getParameter("T3")).trim()%>">
                          		              <input type="text" name="ST3" size="20" maxlength="60" tabindex="2"  value="<%=Gen.gettable(request.getParameter("ST3")).trim()%>" disabled>
       				                         <input type="button" value="..." name="act1" style="font-weight: bold" tabindex="5" onClick="setLink('SHIPPER','T3','ST3','','')">
                                            </label>
    										<label class="control-label">&nbsp;*Feeder:<input type="text" id="T1" name="T1" maxlength="12" size="12" value="<%=gen.gettable(request.getParameter("T1")).trim()%>"/></label>
											<label class="control-label">&nbsp;*Seal No.:<input type="text" id="T2" name="T2" maxlength="20" size="10" value="<%=gen.gettable(request.getParameter("T2")).trim()%>" /> </label>
                                            <label class="control-label">&nbsp;*Get Out Date:<input class="input-medium date-picker" name="T4"  id="T4" type="text" data-date-format="dd-mm-yyyy" value="<%=Gen.gettable(request.getParameter("T4"))%>" placeholder="dd-mm-yyyy"/> </label>
											<label class="control-label">&nbsp;*Free Time:<input type="text" id="T6" name="T6" maxlength="3" size="3" value="<%=gen.gettable(request.getParameter("T6")).trim()%>" /> </label>
                                    <div class="col-sm-offset-1 col-sm-10"></div>
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
                                                            if(s==1)continue;
                                                            
                                                        %>         
														<th><%=judul[s]%></th>
                                                        <%}%>
                                                        <th>Move</th>
    											</tr>
											</thead>

											<tbody>
                                                   <%
                                                   int hic=1,cou=0;
                                                   for(int s=0;s<data.size();s+=judul.length){%>         
												<tr>
                                                       <%for(int ss=0;ss<judul.length;ss++){
                                                            if(ss==1)continue;
                                                            cou++;
                                                       %>
                                                            <td nowrap>
                                                                 <%=gen.gettable(data.get(s+ss)).trim()%>
                                                            </td>
                                                           
                                                        <%}%>
                                                         <td><button onClick="javascript:onact('<%=gen.gettable(data.get(s)).trim()%>','<%=gen.gettable(data.get(s+1)).trim()%>','<%=gen.gettable(data.get(s+2)).trim()%>','<%=gen.gettable(data.get(s+7)).trim()%>')"><img src="image/ok.gif" /></button></td>
												</tr>
                                                <%}%>
											</tbody>
										</table>
								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->
                        </form>
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
            function  refresh(){
                      BGA.submit();
            }
        	function jump(P1,P2,P3){
        		url="movementdetail.jsp?tp=MOVEMENTDETAIL&menu=false&canedit=true&S1="+P1+"&S2="+P2+"&S3="+P3;
        		window.open(url,"", "height=600,width=1400,resize=yes,toolbar=no,scrollbars=yes,menubar=no");
        	}
	function setLink(Pdata,FieldName,FieldName2,cond,listinactive){
		url="RowSetDataSearch.jsp?Type=<%=request.getParameter("tp")%>&Data="+Pdata+"&tt="+FieldName+"&tt1="+FieldName2+"&cond="+cond+"&push=false&link=<%=request.getRequestURI()%>&listinactive="+listinactive;
		window.open(url,"", "height=600,width=900,toolbar=no,scrollbars=yes,menubar=no");
	}
            
            function onact(Parm1,Parm2,Parm3,Parm4){
                var a=true;                
                if(document.BGA.T5.value==''){
                    alert("Please Fill The Export Code");
                    a=false;
                }
                if(document.BGA.T3.value==''){
                    alert("Please Fill The Shipper");
                    a=false;
                }
                if(document.BGA.T1.value==''){
                    alert("Please Fill The Feeder No.");
                    a=false;
                }
                if(document.BGA.T2.value==''){
                    alert("Please Fill The Seal No.");
                    a=false;
                }
                if(document.BGA.T4.value==''){
                    alert("Please Fill The Get Out Date");
                    a=false;
                }
                 var ret = SetTime(Parm4,"D");
                 var get = SetTime(T4.value,"D");
                 if(ret>get){
                      alert("Invalid Get Out Date.Valid (Input Get Out Date>=Return In Depot Date)");
                      a=false;
                 }
                if(document.BGA.T6.value==''){
                    alert("Please Fill The Free Time");
                    a=false;
                }
                 
                 document.BGA.ST3.disabled=false;
                if(a){
                   location.href="toexport.jsp?tp=<%=tp%>&act=Save&T1="+document.BGA.T1.value+"&T2="+document.BGA.T2.value+"&ST3="+document.BGA.ST3.value+"&T3="+document.BGA.T3.value+"&T4="+document.BGA.T4.value+"&T5="+document.BGA.T5.value+"&T6="+document.BGA.T6.value+"&S1="+Parm1+"&S2="+Parm2+"&S3="+Parm3;
               }
            }
            function SetTime(trans,format){
               var y=m=d="";
               y=trans.charAt(6)+trans.charAt(7)+trans.charAt(8)+trans.charAt(9);
               if(format=="M"){
                  m=(trans.charAt(0)+trans.charAt(1))-1;
                  d=trans.charAt(3)+trans.charAt(4);
               }
               else {
                  d=trans.charAt(0)+trans.charAt(1);
                  m=(trans.charAt(3)+trans.charAt(4))-1;
               }
               var transdate = new Date(y,m,d);
               
               return transdate;
            }
            
		</script>
	</body>
</html>
