%dw 2.0 
output application/json
fun prepareList(list:Array, maxSize: Number) = if(sizeOf(list) >= maxSize  )
list
else
prepareList(list ++ [(sizeOf(list) + 1) as Number], maxSize )
---
{
counter : prepareList([],((vars.totalRecords) / vars.offset.limitRecords) - 1 )
}