% Function to calculate service time by exp dist
function serve_time = Service_Job()
serve_time = exprnd(1/25);
end