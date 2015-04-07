using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TisWeb.Models
{
   public  class Biz
    {
        private static string ToUrl(string Code)
        {
            var url = SqlHelper.ExecuteScalarText("select ToUrl from URLMap where UrlCode = @Code", new System.Data.SqlClient.SqlParameter("@Code", Code));
            if (url!=null)
            {
                return url.ToString();
            }
            return null;
        }
        public static void SaveViewHistory(string UrlCode ,out string to)
        {

            to = ToUrl(UrlCode);
            if (to == null)
            {
                return;
            }
            var user = UserInfo.CurrentUser();
            SqlHelper.ExecteNonQueryProcedure("ViewHistory_InsertProcedure",
                 new System.Data.SqlClient.SqlParameter("@ViewHistoryId", Guid.NewGuid()),
                 new System.Data.SqlClient.SqlParameter("@UrlCode", UrlCode),
                 new System.Data.SqlClient.SqlParameter("@IP", user.data.ip),
                 new System.Data.SqlClient.SqlParameter("@ViewDate", DateTime.Now),
                 new System.Data.SqlClient.SqlParameter("@country", user.data.country),
                 new System.Data.SqlClient.SqlParameter("@area", user.data.area),
                 new System.Data.SqlClient.SqlParameter("@province", user.data.province),
                 new System.Data.SqlClient.SqlParameter("@city", user.data.city),
                 new System.Data.SqlClient.SqlParameter("@district", user.data.district),
                 new System.Data.SqlClient.SqlParameter("@linetype", user.data.linetype),
                 new System.Data.SqlClient.SqlParameter("@agent", user.Agent) ,
                 new System.Data.SqlClient.SqlParameter("@os", user.OS) 
                );
        }
    }
}
