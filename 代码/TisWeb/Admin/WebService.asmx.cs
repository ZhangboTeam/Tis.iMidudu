using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using TisWeb.Models;
namespace TisWeb.Admin
{
    /// <summary>
    /// Summary description for WebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
     [System.Web.Script.Services.ScriptService]
    public class WebService : System.Web.Services.WebService
    {

        [WebMethod(EnableSession = true)]
        public bool Login(string userName, string password)
        {
            var ok =  SqlHelper.Exists("select count(1) from SystemUser where LoginName=@LoginName and Password= @Password", new System.Data.SqlClient.SqlParameter("@LoginName", userName), new System.Data.SqlClient.SqlParameter("@Password", password));
            if (ok)
            {
                System.Web.HttpContext.Current.Session["UserName"] = userName;
            }
            return ok;
        }

        [WebMethod(EnableSession = true)]
        public bool Logout()
        {
            System.Web.HttpContext.Current.Session["UserName"] = null;
            return true;
        }

        [WebMethod(EnableSession = true)]
        public bool ChangePassword(string oldpwd, string newpwd, string newpwd2)
        {
            var username = HttpContext.Current.Session["UserName"].ToString();
            if (SqlHelper.Exists("select count(1) from SystemUser where LoginName =@UserName and Password = @Password", new System.Data.SqlClient.SqlParameter("@UserName", username), new System.Data.SqlClient.SqlParameter("@Password", oldpwd)))
            {
                SqlHelper.ExecteNonQueryText("update SystemUser set Password=@Password where LoginName=@UserName",
                 new System.Data.SqlClient.SqlParameter("@UserName", username),
                 new System.Data.SqlClient.SqlParameter("@Password", newpwd));
                return true;
            }
            return false;
        }
        [WebMethod]
        public string AddNewUrlMap(string newUrlCode,string newToUrl)
        {
            SqlHelper.ExecteNonQueryProcedure("URLMap_InsertProcedure",
                 new System.Data.SqlClient.SqlParameter("@UrlCode", newUrlCode),
                 new System.Data.SqlClient.SqlParameter("@ToUrl", newToUrl));
            var count = (int)SqlHelper.ExecuteScalarText("select count(1) from URLMap");
            return string.Format("{0:000}", count++);
        }
        [WebMethod]
        public void DeleteUrlMap(string UrlCode )
        {
            SqlHelper.ExecteNonQueryProcedure("URLMap_DeleteProcedure",
                 new System.Data.SqlClient.SqlParameter("@UrlCode", UrlCode) );
        }
        [WebMethod]
        public void UpdateAllUrlMap(List<UpdateModelUrlMap>  datasssss)
        {
            foreach (var d in datasssss)
            {
                SqlHelper.ExecteNonQueryProcedure("URLMap_UpdateProcedure",
                     new System.Data.SqlClient.SqlParameter("@UrlCode", d.code),
                     new System.Data.SqlClient.SqlParameter("@ToUrl", d.tourl));
            }
        }
    }
    public class UpdateModelUrlMap
    {
        public string code { get; set; }
        public string tourl { get; set; }
    }
}
