﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace PartsHunter
{
    public partial class Form2 : Form
    {
        public string category { get; set; }
        public string box { get; set; }
        public string drawer { get; set; }
        public string description { get; set; }
        public string quantity { get; set; }


        public Form2( string _category, string _box, string _drawer, string _description, string _quantity)
        {
            InitializeComponent();
            category = _category;
            box = _box;
            drawer = _drawer;
            description = _description;
            quantity = _quantity;
           
        }     

        private void Form2_Load(object sender, EventArgs e)
        {
            dataGridView.Rows[0].Cells[0].Value = category;
            dataGridView.Rows[0].Cells[1].Value = box;
            dataGridView.Rows[0].Cells[2].Value = drawer;
            dataGridView.Rows[0].Cells[3].Value = description;
            dataGridView.Rows[0].Cells[4].Value = quantity;

            
            dataGridView.Columns[0].ReadOnly = false;
            dataGridView.Columns[1].ReadOnly = false;
            dataGridView.Columns[2].ReadOnly = false;
            dataGridView.Columns[3].ReadOnly = false;
            dataGridView.Columns[4].ReadOnly = false;
        }

        private void button1_Click(object sender, EventArgs e)
        {            
            this.category = dataGridView.Rows[0].Cells[0].Value.ToString();
            this.box = dataGridView.Rows[0].Cells[1].Value.ToString();
            this.drawer = dataGridView.Rows[0].Cells[2].Value.ToString();
            this.description = dataGridView.Rows[0].Cells[3].Value.ToString();
            this.quantity = dataGridView.Rows[0].Cells[4].Value.ToString();

            this.DialogResult = DialogResult.OK;
            this.Close();
        }
         

    }
}
