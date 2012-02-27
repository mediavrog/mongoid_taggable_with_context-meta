mongoid_taggable_with_context-meta
=============================

NOTE: this is in IMPLEMENTAION PHASE: Not supposed to work right now

[![Build Status](https://secure.travis-ci.org/mediavrog/mongoid_taggable_with_context-meta.png?branch=master)](http://travis-ci.org/mediavrog/mongoid_taggable_with_context-meta)

Extends mongoid_taggable_with_context with support to attach meta information to tags.

Installation
------------

You can simply install from rubygems:

```
gem install mongoid_taggable_with_context-meta
```

or in Gemfile:

```ruby
gem 'mongoid_taggable_with_context-meta'
```

Basic Usage
-----------

To make a document taggable with meta information you need to include Mongoid::TaggableOnContext and Mongoid::TaggableOnContext::Meta into your document and call the *taggable* macro with the argument 'enable_meta' set to true:

```ruby
class Post
  include Mongoid::Document
  include Mongoid::TaggableWithContext
  include Mongoid::TaggableWithContext::Meta

  # default context is 'tags'.
  # This creates #tags, #tags=, #tags_array, #tags_array= instance methods
  taggable :enable_meta => true

  # tagging for 'interests' context.
  # This creates #interests, #interests=, #interests_array, #interests_array= instance methods
  taggable :interests, :enable_meta => true

end
```

Please refer to https://github.com/aq1018/mongoid_taggable_with_context for information on how to use Mongoid::TaggableOnContext

TODO: add dynamic setter for use with form fields, rest ...
-----------------------------------------------------------

-No Support as for now-

Then in your form, for example:

```rhtml
<% form_for @post do |f| %>
  <p>
    <%= f.label :title %><br />
    <%= f.text_field :title %>
  </p>
  <p>
    <%= f.label :content %><br />
    <%= f.text_area :content %>
  </p>
  <p>
    <%= f.label :tags %><br />
    <%= text_field_tag 'post[tags]' %>
  </p>
  <p>
    <%= f.label :interests %><br />
    <%= text_field_tag 'post[interests]' %>
  </p>
  <p>
    <%= f.label :skills %><br />
    <%= text_field_tag 'post[skills]' %>
  </p>
  <p>
    <button type="submit">Send</button>
  </p>
<% end %>
```

Here is an overview ofthe provided methods:

```ruby
p = Post.create!(:tags => "food ant bee")
p.add_tag_with_meta('metatag', {:something => 'Foo', :another => 'Bar'})
p.add_tag_with_meta('metatag2', {:something => 'Foo2', :another => 'Bar2'})

p.tags                      # => "food ant bee metatag metatag2"
p.tags_array                # => ["food", "ant", "bee", "metatag", "metatag2"]
p.tags_having_meta          # => "metatag, metatag2"
p.tags_having_meta_array    # => ["metatag", "metatag2"]
p.tags_including_meta       # =>[ ["food", {}], ["ant", {}], ["bee", {}], ["metatag", {:something => 'Foo', :another => 'Bar'}], ["metatag2", {:something => 'Foo2', :another => 'Bar2'}] ]
```

Contributing to mongoid_taggable_with_context-meta
--------------------------------------------------------

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
---------

Copyright (c) 2012 Maik Vlcek. See LICENSE.txt for
further details.
