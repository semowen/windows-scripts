diskpart
select disk 1
attributes disk clear readonly
online disk 
select disk 1
convert gpt
create partition primary
format quick fs=ntfs
assign letter=L

select disk 2
attributes disk clear readonly
online disk 
select disk 2
convert gpt
create partition primary
format quick fs=ntfs
assign letter=M

select disk 3
attributes disk clear readonly
online disk 
select disk 3
convert gpt
create partition primary
format quick fs=ntfs
assign letter=S

select disk 4
attributes disk clear readonly
online disk 
select disk 4
convert gpt
create partition primary
format quick fs=ntfs
assign letter=W


select disk 5
attributes disk clear readonly
online disk 
select disk 5
convert gpt
create partition primary
format quick fs=ntfs
assign letter=O

select disk 6
attributes disk clear readonly
online disk 
select disk 6
convert gpt
create partition primary
format quick fs=ntfs
assign letter=O

select disk 7
attributes disk clear readonly
online disk 
select disk 7
convert gpt
create partition primary
format quick fs=ntfs
assign letter=O


