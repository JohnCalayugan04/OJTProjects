using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Net.NetworkInformation;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace networkScanner
{
    public partial class Form1 : Form
    {
        int progress = 0;

        public Form1()
        {
            InitializeComponent();

            //adding columns
            dataGridView1.Columns.Add("ipAddress", "IP Address");
            dataGridView1.Columns.Add("hostName", "Host Name");
            dataGridView1.Columns.Add("mac", "MAC");
            dataGridView1.Columns.Add("deviceType", "Device Type");
            dataGridView1.Columns.Add("pingTime", "Ping Time (ms)");

            progressBar1.Minimum = 0;
            progressBar1.Maximum = 254;
        }

        private async void btnScan_Click(object sender, EventArgs e)
        {
            // to prevent multiple scans
            btnScan.Enabled = false;
            btnExport.Enabled = false;

            dataGridView1.Rows.Clear();
            progressBar1.Value = 0;
            progress = 0;

            string baseIP = GetLocalIpAddress();
            string subnet = baseIP.Substring(0, baseIP.LastIndexOf('.') + 1);

            List<Task> tasks = new List<Task>();

            for (int i = 0; i <= 254; i++)
            {
                string ip = subnet + i;
                tasks.Add(ScanDevice(ip));
            }

            await Task.WhenAll(tasks);

            //when scan is done
            //re-enable the button
            btnScan.Enabled = true;
            btnExport.Enabled = true;
            MessageBox.Show("Scan Complete!");
        }

        private async Task ScanDevice(string ipAddress)
        {
            try
            {   
                //asking the target IP if active or not
                Ping ping = new Ping();
                PingReply reply = await ping.SendPingAsync(ipAddress, 100);

                //if success gets the (IP Address, HostName, Mac, DeviceType, PingTime)
                if (reply.Status == IPStatus.Success)
                {
                    string hostName = TryGetHostName(ipAddress);
                    string mac = TryGetMac(ipAddress);
                    string deviceType = GuessDeviceType(hostName, mac);
                    long pingTime = reply.RoundtripTime;
                    
                    //safely updates the UI
                    Invoke(new Action(() =>
                    {
                        dataGridView1.Rows.Add(ipAddress, hostName, mac, deviceType, pingTime);
                    }));
                }
            }
            //i just leave this empty
            catch { }

            // safely updates the progress bar
            Invoke(new Action(() =>
            {
                progress++;
                if (progress <= 254) progressBar1.Value = progress;
            }));
        }

        //this methode is trying to get  the Host Name
        private string TryGetHostName(string ip)
        {
            try
            {
                IPHostEntry entry = Dns.GetHostEntry(ip);
                return entry.HostName;
            }
            catch
            {
                return "Unknown";
            }
        }

        //this methode is trying to get  the Mac
        private string TryGetMac(string ip)
        {
            try
            {
                var process = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = "arp",
                        Arguments = "-a " + ip,
                        RedirectStandardOutput = true,
                        UseShellExecute = false,
                        CreateNoWindow = true
                    }
                };
                process.Start();
                string output = process.StandardOutput.ReadToEnd();
                process.WaitForExit();

                string pattern = @"([a-fA-F0-9]{2}[-:]){5}[a-fA-F0-9]{2}";
                Match match = Regex.Match(output, pattern);
                if (match.Success)
                {
                    return match.Value;
                }
            }

            
            catch { }
            //if fail prints unkown
            return "Unknown";
        }

        private string GuessDeviceType(string hostName, string mac)
        {
            if (hostName.ToLower().Contains("printer") || mac.StartsWith("00:1B:A9")) return "Printer";
            if (hostName.ToLower().Contains("pc") || mac.StartsWith("00:1C:23")) return "PC";
            if (mac == "Unknown") return "Unknown";
            return "Other";
        }

        private string GetLocalIpAddress()
        {
            //this loop finds the actual connected local address
            //ignores disconnected adaptors
            foreach (NetworkInterface ni in NetworkInterface.GetAllNetworkInterfaces())
            {
                if (ni.OperationalStatus == OperationalStatus.Up && ni.NetworkInterfaceType != NetworkInterfaceType.Loopback)
                {
                    foreach (UnicastIPAddressInformation ip in ni.GetIPProperties().UnicastAddresses)
                    {
                        if (ip.Address.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                        {
                            return ip.Address.ToString();
                        }
                    }
                }
            }

            return "127.0.0.1";
        }

        // this method export the data into csv files
        private void btnExport_Click(object sender, EventArgs e)
        {
            if (dataGridView1.Rows.Count == 0)
            {
                MessageBox.Show("No data to export.");
                return;
            }

            SaveFileDialog sfd = new SaveFileDialog();
            sfd.Filter = "CSV Files (*.csv)|*.csv";
            sfd.FileName = "NetworkScan.csv";

            if (sfd.ShowDialog() == DialogResult.OK)
            {
                StringBuilder sb = new StringBuilder();

                // Write headers
                foreach (DataGridViewColumn col in dataGridView1.Columns)
                {
                    sb.Append(col.HeaderText + ",");
                }
                sb.AppendLine();

                // Write rows
                foreach (DataGridViewRow row in dataGridView1.Rows)
                {
                    if (!row.IsNewRow)
                    {
                        foreach (DataGridViewCell cell in row.Cells)
                        {
                            sb.Append(cell.Value?.ToString()?.Replace(",", " ") + ",");
                        }
                        sb.AppendLine();
                    }
                }

                File.WriteAllText(sfd.FileName, sb.ToString(), Encoding.UTF8);
                MessageBox.Show("Exported successfully.");
            }
        }
    }
}