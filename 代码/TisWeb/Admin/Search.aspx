<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/SiteAdmin.Master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" runat="server">
        <script runat="server">
            
            private int totalCount;
            private string Countcitymax;
            public string code;
            private string Countcity;
            
            protected override void OnLoad(EventArgs e)
            {
                base.OnLoad(e);
                if (!IsPostBack)
                {
                    this.LoadData();
                    AspNetPager1.RecordCount = totalCount;
                    //bindData(); //使用url分页，只需在分页事件处理程序中绑定数据即可，无需在Page_Load中绑定，否则会导致数据被绑定两次
                }
            }

            private System.Data.SqlClient.SqlDataReader LoadData()
            {


                code = Request["key"];
                totalCount = (int)TisWeb.Models.SqlHelper.ExecuteScalarText("select count(1) from ViewHistory where  province like '%'+@key +'%' OR UrlCode like '%' +@key+'%'",
                             new System.Data.SqlClient.SqlParameter("@key", this.Request["key"]));
                //var uurl = TisWeb.Models.SqlHelper.ExecuteScalarText("select province from ViewHistory where UrlCode=@key",
                //             new System.Data.SqlClient.SqlParameter("@key", this.Request["key"]).ToString();
                //Countcity = TisWeb.Models.SqlHelper.ExecuteScalarText("select distinct([province]) from ViewHistory where UrlCode=@key",
                //               new System.Data.SqlClient.SqlParameter("@key", this.Request["key"])).ToString();
                //Response.Write(Countcity);
                //Countcity = TisWeb.Models.SqlHelper.ExecuteDataSetText("select province,count(*) from ViewHistory where UrlCode=@key group by province ",
                //              new System.Data.SqlClient.SqlParameter("@key", this.Request["key"])).ToString();
                //Countcity = TisWeb.Models.SqlHelper.ExecuteScalarText("select province,count(province) from ViewHistory where UrlCode=@key group by province ",
                //               new System.Data.SqlClient.SqlParameter("@key", this.Request["key"])).ToString();
                //Countcitymax = TisWeb.Models.SqlHelper.ExecuteScalarText("select province,count(*) as provincesum from ViewHistory group by province ");
                var dr = TisWeb.Models.SqlHelper.ExecuteReaderFromStoredProcedure("StoredProcedure3",
                   new System.Data.SqlClient.SqlParameter("@startIndex", AspNetPager1.StartRecordIndex),
                   new System.Data.SqlClient.SqlParameter("@endIndex", AspNetPager1.EndRecordIndex),
                   new System.Data.SqlClient.SqlParameter("@key", this.Request["key"])
                   );
                
                 //this.Request["key"]
                return dr;
            }
            public override void DataBind()
            {
                this.Repeater1.DataSource = this.LoadData();
                base.DataBind();

            }


            protected void AspNetPager1_PageChanged(object src, EventArgs e)
            {
                this.DataBind();
            }
        </script>
       <script>

           function dosearch() {
               var k = $("#key").val();
               window.location.href = "Search.aspx?key=" + k;
           }
           function DownLoad() {
               var k = $("#key").val();
               var sql = "select URLCode as Code,IP as 浏览者IP,country as 浏览者国家,city as 浏览者城市, [district] as 浏览者市区,os as 浏览者系统,viewdate as 浏览时间 from ViewHistory  where  province like '%" + k + "%' OR UrlCode like '%" + k + "%'";
               var url = "/Admin/OutExcelDown.ashx?filename=扫码用户.xls&sql=" + sql;
               alert(sql);
               window.open(url);
               return;
               var content = $("#content").html();
               var data = { body: content };
               $.ajax({
                   type: "POST",
                   contentType: "application/json",
                   url: "Webservice.asmx/ExcelContentSaveToTemp",
                   data: JSON.stringify(data),
                   dataType: 'json',
                   success: function (fn) {

                       var url = "/Admin/OutExcel.ashx?filename=扫码用户.xls&ContentFile=" + fn.d;
                       window.open(url, "_blank");
                   }
               });


           }
    </script>
    

    <div>
    <label>使用城市查或者code</label><input name="key" type="text"  id="key"  placeholder="城市或者code查询" value="<%=Request["key"] %>" />
        <%--<asp:TextBox ID="key" runat="server" ></asp:TextBox>--%>
    <input type="submit" onclick="dosearch();"  value="搜索"class="alt_btn"/>
      <%--  onclick="dosearch();"--%>
    </div>
    <article class="module width_full">
         
            <header> 

            </header>
            <div class="tab_container">
                <div id="tab1" class="tab_content">
                    <div id="content">
                    <asp:Repeater ID="Repeater1" runat="server">
                        
                        <HeaderTemplate>
                            <table class="tablesorter" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th width="50">code</th>
                                        <th>浏览者IP</th>
                                        <th>浏览者国家</th>
                                        <th>浏览者城市</th>
                                        <th>浏览者市区</th>
                                        <th>浏览者系统</th>
                                        <th>浏览时间</th>
                                    </tr>
                                </thead>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tbody>
                                 <tr>
                                    <td><%#Eval("UrlCode") %></td>   
                                    <td><%#Eval("IP") %></td> 
                                    <td><%#Eval("country") %></td>
                                    <td><%#Eval("province") %></td>
                                    <td><%#Eval("city") %><%#Eval("district") %></td>
                                    <td><%#Eval("os") %></td>
                                    <td><%#Eval("ViewDate") %></td>
                                </tr>
                        </ItemTemplate>
                        <FooterTemplate>

                            </tbody>
                    </table>
                            
                        </FooterTemplate>
                    </asp:Repeater>
                      </div>
                    <webdiyer:AspNetPager ID="AspNetPager1" runat="server" Width="100%" UrlPaging="true" ShowPageIndexBox="Always" PageIndexBoxType="DropDownList" ShowCustomInfoSection="Left"
                        FirstPageText="【首页】"
                        LastPageText="【尾页】" NextPageText="【后页】"
                        PrevPageText="【前页】" NumericButtonTextFormatString="【{0}】" TextAfterPageIndexBox="页" TextBeforePageIndexBox="转到第" HorizontalAlign="right" PageSize="10" OnPageChanged="AspNetPager1_PageChanged" EnableTheming="true" CustomInfoHTML="当前第  <font color='red'><b>%CurrentPageIndex%</b></font> 页,共  %PageCount%  页 ,总共:%RecordCount% 条数据">
                    </webdiyer:AspNetPager>
                     <footer>
            <div class="submit_link">
                <input type="submit" value="导出Excel" class="alt_btn" onclick="DownLoad();"  />
            </div>
                        </footer>
                     <div class="post_message">
                <label>汇总：&nbsp&nbsp&nbsp&nbsp 有</label>
                <label><%#totalCount%></label>
                <label>人扫<%#code%>码&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp <%--分别来自于</label>
                <label><%#Countcity%></label>--%>

                              <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSource4" >
                        <HeaderTemplate>
                            <table class="tablesorter" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th>浏览者城市</th>
                                        <th width="50">数量</th>
                                    </tr>
                                </thead>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tbody>
                                 <tr>
                                    <td><%#Eval("province") %></td>   
                                    <td><%#Eval("count province") %></td> 
                                </tr>
                        </ItemTemplate>
                        <FooterTemplate>

                            </tbody>
                    </table>
                            
                        </FooterTemplate>
                    </asp:Repeater>
                    <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:TisConnectionString %>" SelectCommand="select province,count(*) as 'count province'
 from ViewHistory where UrlCode=@UrlCode group by province ">
            <SelectParameters>
                <%--<asp:SessionParameter DefaultValue="001" Name="UrlCode" SessionField="key" Type="String" />--%>
                <%--<asp:FormParameter DefaultValue="001" FormField="key" Name="UrlCode" Type="String" />--%>
                <asp:QueryStringParameter Name="UrlCode" QueryStringField="key" Type="String" />
                <%--<asp:ControlParameter ControlID="key" Name="UrlCode" PropertyName="Text" Type="String" />--%>
            </SelectParameters>
        </asp:SqlDataSource>
            </div>
            
                </div>
                <!-- end of #tab1 -->



            </div>
            <!-- end of .tab_container -->
        
        </article>
           
    <%--</form>--%>
</asp:Content>