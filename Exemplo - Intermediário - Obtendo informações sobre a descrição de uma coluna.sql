declare @ColumnName nvarchar(300), @TableName nvarchar(300);
set @ColumnName= N'...';
set @TableName= N'...';

select 
        st.name [Table],
        sc.name [Column],
        sep.value [Description]
    from sys.tables st
    inner join sys.columns sc on st.object_id = sc.object_id
    left join sys.extended_properties sep on st.object_id = sep.major_id
                                         and sc.column_id = sep.minor_id
                                         and sep.name = 'MS_Description'
    where st.name = @TableName
    and sc.name = @ColumnName;