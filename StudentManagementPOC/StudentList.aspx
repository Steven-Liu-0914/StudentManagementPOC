<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StudentList.aspx.cs" Inherits="StudentManagementPOC.StudentList" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Student List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <script type="text/javascript">
        function confirmDelete(studentName) {
            return confirm('Are you sure you want to delete student: ' + studentName + '?');
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" class="container mt-4">
        <h2 class="mb-4">Student Management</h2>
        <asp:LinkButton ID="btnCreateNew" runat="server" CssClass="btn btn-success mb-3" OnClick="btnCreateNew_Click"><i class="fa fa-plus"></i> Create New Student</asp:LinkButton>
        <asp:GridView ID="gvStudents" runat="server" AutoGenerateColumns="False" DataKeyNames="StudentID"
            CssClass="table table-striped table-hover"
            OnRowCommand="gvStudents_RowCommand">
            <Columns>
                <asp:BoundField DataField="StudentID" HeaderText="ID" ReadOnly="True" />
                <asp:BoundField DataField="FirstName" HeaderText="First Name" />
                <asp:BoundField DataField="LastName" HeaderText="Last Name" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="CreatedAt" HeaderText="Created At" DataFormatString="{0:yyyy-MM-dd HH:mm}" ReadOnly="True" />
                <asp:BoundField DataField="UpdatedAt" HeaderText="Updated At" DataFormatString="{0:yyyy-MM-dd HH:mm}" ReadOnly="True" />
                <asp:TemplateField HeaderText="Actions">
                    <ItemTemplate>
                        <asp:HyperLink ID="hlDetails" runat="server"
                            NavigateUrl='<%# "StudentDetails.aspx?StudentID=" + Eval("StudentID") %>'
                            CssClass="btn btn-primary btn-sm me-1">Details</asp:HyperLink>
                        <asp:LinkButton ID="lnkDelete" runat="server" CommandName="CustomDelete"
                            CommandArgument='<%# Eval("StudentID") %>'
                            OnClientClick='<%# "return confirmDelete(\"" + Eval("FirstName") + " " + Eval("LastName") + "\");" %>'
                            CssClass="btn btn-danger btn-sm">Delete</asp:LinkButton>

                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <EmptyDataTemplate>
                <div class="text-center">
                    No records found.
                </div>
            </EmptyDataTemplate>
        </asp:GridView>
    </form>
</body>
</html>
