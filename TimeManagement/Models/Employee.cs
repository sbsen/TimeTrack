//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace TimeManagement.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class Employee
    {
        public Employee()
        {
            this.Tasks = new HashSet<Task>();
            this.EmployeeRoles = new HashSet<EmployeeRole>();
            this.EmployeeProjects = new HashSet<EmployeeProject>();
            this.WeeklyReports = new HashSet<WeeklyReport>();
        }
    
        public int Id { get; set; }
        public int LocationId { get; set; }
        public string Prefix { get; set; }
        public string FirstName { get; set; }
        public string MiddleName { get; set; }
        public string LastName { get; set; }
        public string Suffix { get; set; }
        public Nullable<decimal> BillRate { get; set; }
        public string CompanyName { get; set; }
        public Nullable<decimal> Cost { get; set; }
        public string EmployeeCode { get; set; }
        public string DOB { get; set; }
        public string DOJ { get; set; }
        public string Email { get; set; }
        public string Mobile { get; set; }
        public string DOR { get; set; }
        public Nullable<bool> EmailReminder { get; set; }
    
        public virtual Location Location { get; set; }
        public virtual ICollection<Task> Tasks { get; set; }
        public virtual Login Login { get; set; }
        public virtual ICollection<EmployeeRole> EmployeeRoles { get; set; }
        public virtual ICollection<EmployeeProject> EmployeeProjects { get; set; }
        public virtual ICollection<WeeklyReport> WeeklyReports { get; set; }
    }
}
