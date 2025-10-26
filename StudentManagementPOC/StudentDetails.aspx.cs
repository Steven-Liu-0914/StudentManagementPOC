using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace StudentManagementPOC
{
    public partial class StudentDetails : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["StudentDBConnection"].ConnectionString;
        protected bool IsCreateMode = true;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                pnlStudentEdit1.Visible = true;
                pnlStudentEdit2.Visible = true;

                if (Request.QueryString["StudentID"] != null)
                {
                    IsCreateMode = false;
                    int studentID = Convert.ToInt32(Request.QueryString["StudentID"]);
                    LoadStudent(studentID);
                }
                else
                {
                    pnlStudent.Visible = true;
                }

                if (IsCreateMode)
                {
                    pnlStudentEdit1.Visible = false;
                    pnlStudentEdit2.Visible = false;
                }
            }
        }

        private void LoadStudent(int studentID)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("sp_GetStudents", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@StudentID", studentID);
                conn.Open();
                var dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    pnlStudent.Visible = true;
                    txtStudentID.Text = dr["StudentID"].ToString();
                    txtFirstName.Text = dr["FirstName"].ToString();
                    txtLastName.Text = dr["LastName"].ToString();
                    txtEmail.Text = dr["Email"].ToString();
                    txtCreatedAt.Text = Convert.ToDateTime(dr["CreatedAt"]).ToString("yyyy-MM-dd HH:mm");
                    txtUpdatedAt.Text = Convert.ToDateTime(dr["UpdatedAt"]).ToString("yyyy-MM-dd HH:mm");
                }
            }
        }

        private bool IsEmailExists(string email, int? studentID = null)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand("sp_CheckEmailExists", conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@StudentID", (object)studentID ?? DBNull.Value);

                conn.Open();
                var result = cmd.ExecuteScalar();
                int flag = 0;
                if (result != null && int.TryParse(result.ToString(), out flag))
                    return flag == 1;
                return false;
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;

            string firstName = txtFirstName.Text.Trim();
            string lastName = txtLastName.Text.Trim();
            string email = txtEmail.Text.Trim();

            if (firstName.Length == 0 || firstName.Length > 255 || lastName.Length == 0 || lastName.Length > 255)
            {
                lblError.Text = "First Name / Last Name must be 1-255 characters.";
                lblError.Visible = true;
                return;
            }

            if (!System.Text.RegularExpressions.Regex.IsMatch(firstName, @"^[A-Za-z]+$") ||
                !System.Text.RegularExpressions.Regex.IsMatch(lastName, @"^[A-Za-z]+$"))
            {
                lblError.Text = "First Name / Last Name can only contain letters.";
                lblError.Visible = true;
                return;
            }

            if (!System.Text.RegularExpressions.Regex.IsMatch(email, @"^[^\s@]+@[^\s@]+\.[^\s@]+$") || email.Length > 255)
            {
                lblError.Text = "Invalid email format or too long.";
                lblError.Visible = true;
                return;
            }

            int? editingStudentId = string.IsNullOrEmpty(txtStudentID.Text) ? (int?)null : Convert.ToInt32(txtStudentID.Text);
            if (IsEmailExists(email, editingStudentId))
            {
                lblError.Text = "Email already exists.";
                lblError.Visible = true;
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = conn;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    if (editingStudentId == null)
                    {
                        cmd.CommandText = "sp_CreateStudent";
                    }
                    else
                    {
                        cmd.CommandText = "sp_UpdateStudent";
                        cmd.Parameters.AddWithValue("@StudentID", editingStudentId.Value);
                    }

                    cmd.Parameters.AddWithValue("@FirstName", firstName);
                    cmd.Parameters.AddWithValue("@LastName", lastName);
                    cmd.Parameters.AddWithValue("@Email", email);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                Response.Redirect("StudentList.aspx");
            }
            catch (Exception ex)
            {
                lblError.Text = "Unexpected error: " + ex.Message;
                lblError.Visible = true;
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("StudentList.aspx");
        }
    }
}