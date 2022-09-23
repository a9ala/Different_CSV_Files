####### This script works to compare column "Name" between different .CSV files and export the result to a different file #######
####### Make sure all files saved in .csv extension #### ####### Make sure all files has "Name" column for comparison #######
####### The SideIndicator column "==" Indicates the content is present in both files,"=>" Indicates the content only exists in the -DifferenceObject file , "=>" Indicates the content only exists in the -ReferenceObject file ####### 
#######Change paths for  imported files and Export file  ####### 

#import all desired files        #######   Change path #######   
$ListToCompareTo = import-csv -Path "C:\Users\User\Documents\The_Compare_List.csv"  
$FirstList = import-csv -Path "C:\Users\User\Documents\FirrstList.csv" 
$SecondList = import-csv -Path "C:\Users\User\Documents\SecondList.csv" 
$ThirdList = import-csv -Path "C:\Users\User\Documents\ThirdList.csv"    
#$FourthList = import-csv -Path "C:\Users\User\Documents\FourthList.csv" 
#$FifthList = import-csv -Path "C:\Users\User\Documents\FifthList.csv"

#Create a list to save all values 
$CList1, $Clist2 ,$Clist3= @() #, $Clist4, $Clist5 

# Compare the list you want to other lists +                                                                                       ### Adding a column indicates to which list we compare this value to   
$CFile1= Compare-Object -ReferenceObject $ListToCompareTo -DifferenceObject $FirstList -Property 'Name' -includeequal| Select-Object *,@{Name='Managed by';Expression={'First tList'}}| Group-Object -Property Name 
$CList1 += ($CFile1 | Where{$_.Count -gt 1}).Group | Where{$_.SideIndicator -eq '=='} ##Helps with inaccuracy that duplicate values from first file might cause 
$CList1+= ($CFile1 | Where{$_.Count -eq 1}).Group

$CFile2= Compare-Object -ReferenceObject $ListToCompareTo -DifferenceObject $SecondList -Property 'Name' -includeequal| Select-Object *,@{Name='Managed by';Expression={'Second List'}} |  Group-Object -Property Name 
$CList2 += ($CFile2 | Where{$_.Count -gt 1}).Group | Where{$_.SideIndicator -eq '=='} 
$CList2+= ($CFile2 | Where{$_.Count -eq 1}).Group

$CFile3= Compare-Object -ReferenceObject $ListToCompareTo -DifferenceObject $ThirdList -Property 'Name' -includeequal| Select-Object *,@{Name='Managed by';Expression={'Third List'}} |  Group-Object -Property Name 
$CList3 += ($CFile3 | Where{$_.Count -gt 1}).Group | Where{$_.SideIndicator -eq '=='}
$CList3+= ($CFile3 | Where{$_.Count -eq 1}).Group

#$CFile4= Compare-Object -ReferenceObject $ListToCompareTo -DifferenceObject $FourthList -Property 'Name' -includeequal| Select-Object *,@{Name='Managed by';Expression={'Fourth List'}}|  Group-Object -Property Name 
#$CList4 += ($CFile4 | Where{$_.Count -gt 1}).Group | Where{$_.SideIndicator -eq '=='} 
#$CList4+= ($CFile4 | Where{$_.Count -eq 1}).Group

#$CFile5= Compare-Object -ReferenceObject $ListToCompareTo -DifferenceObject $FifthList -Property 'Name' -includeequal| Select-Object *,@{Name='Managed by';Expression={'Fifth List'}}|  Group-Object -Property Name 
#$CList5 += ($CFile5| Where{$_.Count -gt 1}).Group | Where{$_.SideIndicator -eq '=='} 
#$CList5+= ($CFile5 | Where{$_.Count -eq 1}).Group


#Merge lists together and export it to a file

$merged =$CList1 + $CList2 + $CList3 # + $CList4 + $CList5
                                            #######   Change path #######
$merged | Select -Property * | Export-Csv C:\Users\AHasan\Documents\EndPointSecurityAudit\ClientsList.csv









