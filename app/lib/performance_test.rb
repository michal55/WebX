x = 10
t1 = Time.now
for i in 0..x do
  # Http.get('http://0.0.0.0:3000/webx/api/export/extraction?token=xkmu2wvr6uhisr6iau2g&id=67')
  Http.get('http://team16-16.studenti.fiit.stuba.sk/webx/api/export/extraction?token=i3frtx90v6i3wynz63jb&id=6')
end
t2 = Time.now
puts(x, ' requests in ', t2-t1)

# spusti: rails runner ./app/lib/performance_test.rb
