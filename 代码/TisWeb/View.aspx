<%@ Page Language="C#"  %>
 
<%
    var user = TisWeb.Models.UserInfo.CurrentUser();
    if (user.state !=1)
    {
        Response.End();
    }
    var code = this.Request["code"];
    if (string.IsNullOrEmpty(code))
    {
        Response.End();
    }
    string to;
    TisWeb.Models.Biz.SaveViewHistory(code,out to);
    if (to!=null)
    {
        this.Response.Redirect(to);
    }
     %>
<%=user.data.ip %>
<%=user.data.linetype %>
<%=user.data.province %>
<%=user.data.district %>
<%=user.data.country %>
<%=user.data.city %>
<%=user.data.area %>
<%=user.OS %>
<%=user.Agent %>