#Country Flag Dispay GUI
#gets the information from public API https://restcountries.com, Thanks to Restcountries API

[void]([System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms"))
[void]([System.Reflection.Assembly]::LoadWithPartialName("system.Drawing"))
Add-Type -AssemblyName system.windows.Forms

#Main Form
$MainForm = New-Object System.Windows.Forms.Form
$MainForm.ClientSize = '700,500'
$MainForm.Text = "Country Flag Display App"


#Title Lable
$MainTitle = New-Object System.Windows.Forms.Label
$MainTitle.Text = "Know Your Country"
$MainTitle.AutoSize = $true
$MainTitle.BackColor = "Green"
$MainTitle.ForeColor = "White"
$MainTitle.Font = [System.Drawing.Font]::new("Microsoft Scan Serif", 12 , [System.Drawing.FontStyle]::Bold)
$MainTitle.Font = [System.Drawing.Font]::new("Microsoft Scan Serif", 12 , [System.Drawing.FontStyle]::Underline)
$MainTitle.Location = New-Object System.Drawing.Point(230,05)

#country Name input text box
$Cinput = New-Object System.Windows.Forms.TextBox
$Cinput.Height = 90
$Cinput.Width = 150
$Cinput.BackColor = "Yellow"
$Cinput.Location = New-Object System.Drawing.Point(200,50)

#submit button
$Submitbtn = New-Object System.Windows.Forms.Button
$Submitbtn.Height = 20
$Submitbtn.Width = 60
$Submitbtn.Text = "SUBMIT"
$Submitbtn.AutoSize = $true
$Submitbtn.Location = New-Object System.Drawing.Point(450,50)

#country name lable
$countryName = New-Object System.Windows.Forms.Label
$countryName.Text = "Enter Country Code and Click Submit"
$countryName.Location = New-Object System.Drawing.Point(200,90)
$countryName.Font = [System.Drawing.Font]::new("Microsoft Scan Serif", 12 , [System.Drawing.FontStyle]::Bold)
$countryName.AutoSize = $true

#country Capital Lable
$capital = New-Object System.Windows.Forms.Label
$capital.Text = "Capital:"
$capital.Location = New-Object System.Drawing.Point(200,120)
$capital.AutoSize = $true

#Flag picture box
$FlagPic = New-Object System.Windows.Forms.PictureBox
$FlagPic.Location = New-Object System.Drawing.Point(200,160) 

#add controls to the main form 
$MainForm.Controls.AddRange(@($MainTitle,$Cinput,$Submitbtn,$countryName, $capital,$FlagPic))

$Submitbtn.add_click({
    if($Cinput.Text){
        
        $cname = $Cinput.Text
        Write-Host "Input County Code is: "$cname
        try{
            $ErrorActionPreference = 'stop'
            $CountryData = Invoke-RestMethod -Method Get -Uri "https://restcountries.com/v2/alpha/$($cname)"
            $image = $CountryData.Flags.png
            $countryName.Text = "Country Name: "+$CountryData.Name
            $capital.Text = "Capital: "+$CountryData.Capital

            $wc = New-Object System.Net.WebClient
            $flag = "C:\CountryFlag_$cname.png"
            if(Test-Path -Path $flag){
                
                $fpic = [System.Drawing.Image]::FromFile($flag)
            }
            else{
                $wc.DownloadFile($image,$flag)
                $fpic = [System.Drawing.Image]::FromFile($flag)
            }
                        
            [System.Windows.Forms.Application]::EnableVisualStyles()
            $FlagPic.Image = $fpic
            $FlagPic.Height = $fpic.Height
            $FlagPic.Width = $fpic.Width

            $MainForm.Controls.Add($FlagPic)
        }catch{
            $errmsg =  $_.Exception
            Write-Host $errmsg        
            $countryName.Text = "Check Country Code"
            $FlagPic.Image = $null
        }
    }
    else{
        $countryName.Text = "Enter Country Code and Click Submit"
        $capital.Visible = $false
        $FlagPic.Image = $null
    }
})
$MainForm.ShowDialog()
#Script ended here

