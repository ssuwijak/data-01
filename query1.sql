select *,
iif(isnumeric(NetWeight_1)=1,convert(float,NetWeight_1),0.0) NetWeight_2,
iif(Found_oz_ct=1,iif(isnumeric(NetWeight_1)=1,'True','False'),'-') [NetWeight_Integrity]
from (
	select *,
	case when Found_oz_ct=0 then '0.0'
		when ct_sub='-' then substring(oz_sub,1,len(oz_sub)-2)
		when oz_sub='-' then substring(ct_sub,1,len(ct_sub)-2)
		else lower(oz_sub + ' + ' + ct_sub)
	end as NetWeight_1

from (
	select ShortDescription,NetWeight,
	reverse(iif(oz_Pos1>0,substring(name_r,oz_Pos1,abs(oz_Pos2-oz_Pos1)),'-')) oz_sub,
	reverse(iif(ct_Pos1>0,substring(name_r,ct_Pos1,abs(ct_Pos2-ct_Pos1)),'-')) ct_sub,
	iif(oz_Pos1+ct_Pos1=0,0,1) Found_oz_ct
from (
	select ShortDescription,reverse(ShortDescription) name_r,
	NetWeight,len(ShortDescription) [length],
	charindex(reverse('oz'),reverse(ShortDescription)) oz_Pos1,
	charindex(' ',reverse(ShortDescription),charindex(reverse('oz'),reverse(ShortDescription))) oz_Pos2,
	charindex(reverse('ct'),reverse(ShortDescription)) ct_Pos1,
	charindex(' ',reverse(ShortDescription),charindex(reverse('ct'),reverse(ShortDescription))) ct_Pos2
from xx) as t1
-- where oz_Pos2<=oz_Pos1 or ct_Pos2<=ct_Pos1
) as t2
) as t3
-- where isnumeric(NetWeight_1)=0 
; 