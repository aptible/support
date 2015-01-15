---
title: WTF is docker?
---


<section>
# Introduction (h1)

This guide will help you deploy your first Ruby app on Aptible. Pellentesque eget ex suscipit, pulvinar velit eu, viverra orci. Integer sit amet metus at ante posuere sagittis.

## Requirements (h2)

Curabitur convallis lacus a pretium fermentum. Donec ut ultrices enim, ac interdum sem. Nam et nisl sed quam consequat feugiat. Curabitur vehicula at purus nec mollis.
</section>

<section>
# Section 2

### Other (h3)

This guide will help you deploy your first Ruby app on Aptible. Pellentesque eget ex suscipit, pulvinar velit eu, viverra orci. Integer sit amet metus at ante posuere sagittis.

#### More other (h4)

This guide will help you deploy your first Ruby app on Aptible. Pellentesque eget ex suscipit, pulvinar velit eu, viverra orci. Integer sit amet metus at ante posuere sagittis.

##### Some code, yo (h5)

```ruby
def show
  @app = Aptible::Api::App.find(params[:id], token: service_token)
  render json: @app.attributes if request.xhr?
end
```
</section>