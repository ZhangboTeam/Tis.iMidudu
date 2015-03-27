<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/SiteAdmin.Master"   %>
<%--<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/SiteAdmin.Master" AutoEventWireup="true" CodeBehind="TimeSearch.aspx.cs" Inherits="TisWeb.Admin.TimeSearch">--%>
<script runat="server"> 

    private int totalCount;
    //private int totalCount2;
    //private int totalCount50;
    //private int totalOpenId;
    //private double totalMoney;

    protected override void OnLoad(EventArgs e)
    {
        base.OnLoad(e);
        if (!IsPostBack)
        {
            if (string.IsNullOrEmpty(this.Request["key1"]) ||string.IsNullOrEmpty(this.Request["key2"]))
            {
                return;
            }
            this.LoadData();
            AspNetPager1.RecordCount = totalCount;
            //bindData(); //使用url分页，只需在分页事件处理程序中绑定数据即可，无需在Page_Load中绑定，否则会导致数据被绑定两次
        }
    }

    private System.Data.SqlClient.SqlDataReader LoadData()
    {
        //var keyb = new System.Data.SqlClient.SqlParameter("@beginDate", DateTime.Parse(this.Request["key1"]));
        //var keye = new System.Data.SqlClient.SqlParameter("@endDate", DateTime.Parse(this.Request["key2"]).AddDays(1));
        totalCount = (int)TisWeb.Models.SqlHelper.ExecuteScalarText("select count(1) from ViewHistory");
        var dr = TisWeb.Models.SqlHelper.ExecuteReaderFromStoredProcedure("StoredProcedure7",
           new System.Data.SqlClient.SqlParameter("@startIndex", AspNetPager1.StartRecordIndex),
           new System.Data.SqlClient.SqlParameter("@endIndex", AspNetPager1.EndRecordIndex),
           new System.Data.SqlClient.SqlParameter("@keyb", this.Request["key1"]),
           new System.Data.SqlClient.SqlParameter("@keye", this.Request["key2"])
           );
        //Console.WriteLine(DateTime.Parse(this.Request["key2"]));
        //var cmd = new System.Data.SqlClient.SqlCommand();
        //var cn = new System.Data.SqlClient.SqlConnection(System.Web.Configuration.WebConfigurationManager.AppSettings["con"]);
        //cmd.Connection = cn;
        //cmd.CommandType = System.Data.CommandType.StoredProcedure;
        //cmd.CommandText = "StoredProcedure7";
        //cmd.Parameters.AddRange(new System.Data.SqlClient.SqlParameter[] {
        //   new System.Data.SqlClient.SqlParameter("@startIndex", AspNetPager1.StartRecordIndex),
        //   new System.Data.SqlClient.SqlParameter("@endIndex", AspNetPager1.EndRecordIndex),
        //   keyb,keye
        //});
        //cn.Open();
        //var dr = cmd.ExecuteReader(System.Data.CommandBehavior.CloseConnection);
        //var key4=this.Request["key2"];
        //DateTime key3 = Convert.ToDateTime(key4);
        //key3 = key3.AddDays(1);
        //string sql1 = string.Format("select  count(*) from ViewBonusHistory where receiptdate >='{0}' and receiptdate <'{1}'", this.Request["key1"], key3);
        //string sql2 = string.Format("select  isnull(count(*),0) from ViewBonusHistory where receiptdate >='{0}' and receiptdate <'{1}'", this.Request["key1"], key3);
        //string sql3 = string.Format("select  isnull(count(*),0) from ViewBonusHistory where Amount=2 and receiptdate >='{0}' and receiptdate <'{1}'", this.Request["key1"], key3);
        //string sql4 = string.Format("select  isnull(count(*),0) from ViewBonusHistory where Amount=50 and receiptdate >='{0}' and receiptdate <'{1}'", this.Request["key1"], key3);
        //string sql5 = string.Format("select  isnull(count(distinct([OpenId] )),0) from ViewBonusHistory  where receiptdate >='{0}' and receiptdate <'{1}'", this.Request["key1"], key3);
        //string sql6 = string.Format("select  isnull(SUM(amount),0) from ViewBonusHistory where receiptdate >='{0}' and receiptdate <'{1}'", this.Request["key1"], key3);
        ////this.totalCount = (int)iMidudu.SystemDAO.SqlHelper.ExecuteScalarText(sql1);

        //this.totalCount = (int)TisWeb.Models.SqlHelper.ExecuteScalarText(sql2);
        //this.totalCount2 = (int)TisWeb.Models.SqlHelper.ExecuteScalarText(sql3);
        //this.totalCount50 = (int)TisWeb.Models.SqlHelper.ExecuteScalarText(sql4);
        //this.totalOpenId = (int)TisWeb.Models.SqlHelper.ExecuteScalarText(sql5);
         //try
         //{
         //    this.totalMoney = (double)TisWeb.Models.SqlHelper.ExecuteScalarText(sql6);
         //}
         //catch
         //{
         //    this.totalMoney = 0;
         //}
        return dr;
    }
    public override void DataBind()
    {
        if (string.IsNullOrEmpty(this.Request["key1"]) ||string.IsNullOrEmpty(this.Request["key1"]))
        {
            return;
        }
        if (string.IsNullOrEmpty(this.Request["key2"]) ||string.IsNullOrEmpty(this.Request["key2"]))
        {
            return;
        }
        this.Repeater1.DataSource = this.LoadData();
        base.DataBind();

    }


    protected void AspNetPager1_PageChanged(object src, EventArgs e)
    {
        this.DataBind();
    }
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="PageBody" runat="server">
    <script>

        function dosearch() {
            var key1 = $("#key1").val();
            var key2 = $("#key2").val();
            if (key1 == "" || key1 == null) {
                // return;
            }
            if (key2 == "" || key2 == null) {
                // return;
            }
            window.location.href= "TimeSearch.aspx?key1=" + key1 + "&key2=" + key2;
        }
    </script>
     
        <div class="quick_search ">
            <input type="text" id="key1" value="<%=DateTime.Today.AddDays(-7).ToString("yyyy-MM-dd") %>" style="width:auto;" />
			<input type="text"id="key2" value="<%=DateTime.Today.ToString("yyyy-MM-dd") %>"  style="width:auto;"/>
                <input type="submit" value="搜索" onclick="dosearch();" class="alt_btn"/>
		</div> 
    <article class="module width_full">
        <header>
            <h3 class="tabs_involved">按时间查询</h3>

        </header>
        <div class="tab_container">
            <div id="tab1" class="tab_content">
                 


                <asp:Repeater ID="Repeater1" runat="server">
                    <HeaderTemplate>
                            <table class="tablesorter" cellspacing="0">
                    <thead>
                        <tr>
                                        <th width="50">code</th>
                                        <th>浏览者IP</th>
                                        <th>浏览者国家</th>
                                        <th>浏览者城市</th>
                                        <th>浏览者系统</th>
                                        <th>浏览时间</th>
                                    </tr>
                    </thead>
                    <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                                    <td><%#Eval("UrlCode") %></td>   
                                    <td><%#Eval("IP") %></td> 
                                    <td><%#Eval("country") %></td>
                                    <td><%#Eval("city") %></td>
                                    <td><%#Eval("os") %></td>

                                    <td><%#Eval("ViewDate") %></td>
                                </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        
                    </tbody>
                </table>
                    </FooterTemplate>
                </asp:Repeater>

                <webdiyer:AspNetPager ID="AspNetPager1" runat="server" Width="100%" UrlPaging="true" ShowPageIndexBox="Always" PageIndexBoxType="DropDownList"  
                    FirstPageText="【首页】"
    LastPageText="【尾页】" NextPageText="【后页】"
        PrevPageText="【前页】" NumericButtonTextFormatString="【{0}】"   TextAfterPageIndexBox="页" TextBeforePageIndexBox="转到第"  HorizontalAlign="right" PageSize="10" OnPageChanged="AspNetPager1_PageChanged" EnableTheming="true" CustomInfoHTML="Page  <font color='red'><b>%CurrentPageIndex%</b></font> of  %PageCount%  Order %StartRecordIndex%-%EndRecordIndex%">
                </webdiyer:AspNetPager>
            </div>
            <!-- end of #tab1 -->



        </div>
        <!-- end of .tab_container -->
        <footer>
                   <div class="post_message">
                <label>汇总：&nbsp&nbsp&nbsp&nbsp 有</label>
                <label><% %></label>
                <label>人扫码&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp 其中</label>
                <label><% %></label>
                <label>人最多&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp </label>
                <label><% %>被扫最多</label>
            </div>
            <div class="submit_link">
                <input type="submit" value="导出表格" class="alt_btn"/>
            </div>
        </footer>
    </article>


</asp:Content>