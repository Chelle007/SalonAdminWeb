<%
        com.ysoft.General Gen = new com.ysoft.General();
        com.ysoft.General gen = new com.ysoft.General();  
        com.ysoft.subgeneral sgen = new com.ysoft.subgeneral();
        com.ysoft.QueryClass query = new com.ysoft.QueryClass();
        java.util.Enumeration enu = request.getParameterNames();
 	    while (enu.hasMoreElements()){
   		 	String pr =Gen.gettable(enu.nextElement());
          //  System.out.println(pr+"="+Gen.gettable(request.getParameter(pr)));
        }        

  		com.ysoft.DBConnectionManager connMgr = com.ysoft.DBConnectionManager.getInstance();
      	java.sql.Connection conn = connMgr.getConnection("db2");
        java.util.Vector R1=sgen.getDataQuery(conn,"REMINDSTOCK",new String[0]);
        java.util.Vector R2=sgen.getDataQuery(conn,"REMINDBOOKADVANCE",new String[0]);
//[BOOKING_ID],BOOKING.[MEMBER_ID],MEMBER_NAME,MEMBER.CONTACT_NO,BOOKING.[TREATMENT_ID],TREATMENT_NAME,BOOKING.[EMPLOYEE_ID],EMPLOYEE_NAME,[BOOKED_DATE
         connMgr.freeConnection("db2", conn);
          connMgr.release();

%>
			<div class="main-content">
				<div class="main-content-inner">
                    <div class="page-content">
						<div class="row">
							<div class="col-xs-12">
								<!-- PAGE CONTENT BEGINS -->
								<div class="row">
									<div class="col-sm-5">
										<div class="widget-box transparent">
											<div class="widget-header widget-header-flat">
												<h4 class="widget-title lighter">
													<i class="ace-icon fa fa-star orange"></i>
													Stock Need Order
												</h4>

												<div class="widget-toolbar">
													<a href="#" data-action="collapse">
														<i class="ace-icon fa fa-chevron-up"></i>
													</a>
												</div>
											</div>

											<div class="widget-body">
												<div class="widget-main no-padding">
													<table class="table table-bordered table-striped">
														<thead class="thin-border-bottom">
															<tr>
																<th>
																	Id
																</th>
																<th>
																	Item Name
																</th>

																<th>
																	Stock
																</th>

																<th >
																	Minimum Stock
																</th>
															</tr>
														</thead>

														<tbody>
                                                        <%
                                                        for(int m=0;m<R1.size();m+=4){
                                                        %>
															<tr>
																<td nowrap><%=gen.gettable(R1.get(m))%></td>
																<td nowrap><%=gen.gettable(R1.get(m+1))%></td>
                                                                <td nowrap><%=gen.gettable(R1.get(m+2))%></td>
     																<td nowrap><%=gen.gettable(R1.get(m+3))%></td>                                                           
																</tr>
                                                        <%}%>
														</tbody>
													</table>
                                                    
												</div><!-- /.widget-main -->
											</div><!-- /.widget-body -->
                                            <p>
											<div class="widget-header widget-header-flat">
												<h4 class="widget-title lighter">
													<i class="ace-icon fa fa-star orange"></i>
													Need Contact Member in Advance
												</h4>

												<div class="widget-toolbar">
													<a href="#" data-action="collapse">
														<i class="ace-icon fa fa-chevron-up"></i>
													</a>
												</div>
											</div>
											<div class="widget-body">
												<div class="widget-main no-padding">
													<table class="table table-bordered table-striped">
														<thead class="thin-border-bottom">
															<tr>
																<th width="20%">
																	Id
																</th>
																<th nowrap>
																Member Name
																</th>

																<th width="20%">
																	Treatment
																</th>

																<th nowrap>
																	Personal In Charge
																</th>
																<th nowrap>
																	Booking Date
																</th>
															</tr>
														</thead>

														<tbody>
                                                        <%
                                                        for(int m=0;m<R2.size();m+=9){
                                                        %>
															<tr>
																<td nowrap><%=gen.gettable(R2.get(m))%></td>
																<td nowrap><%=gen.gettable(R2.get(m+2))%> (Phone:<%=gen.gettable(R2.get(m+3))%>)</td>
																<td nowrap><%=gen.gettable(R2.get(m+5))%></td>
                                                                <td nowrap><%=gen.gettable(R2.get(m+7))%></td>
     																<td nowrap><%=gen.gettable(R2.get(m+8))%></td>                                                           
																</tr>
                                                        <%}%>
														</tbody>
													</table>
                                                    
												</div><!-- /.widget-main -->
											</div><!-- /.widget-body -->
										</div><!-- /.widget-box -->
									</div><!-- /.col -->
								</div><!-- /.row -->

								<!-- PAGE CONTENT ENDS -->
							</div><!-- /.col -->
						</div><!-- /.row -->
					</div><!-- /.page-content -->
				</div>
			</div><!-- /.main-content -->
