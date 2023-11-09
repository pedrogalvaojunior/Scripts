SELECT
    'USE [master]; GRANT CONNECT ON ENDPOINT::[' + [name] COLLATE SQL_Latin1_General_CP1_CI_AI + '] TO [public];' AS GrantCmd
FROM
    sys.endpoints
WHERE
    is_admin_endpoint = 0
Go