# showcase

(This is a work in progress.)

A sample Rails 4.0 app (a microblogging service) that tries to decouple
application logic from both the Database and Rails itself.

Everything under `lib/showcase` doesn't depend in any way on Rails. For now the
only interesting thing is `lib/showcase/timeline.rb` and its spec
`spec/showcase/timeline_spec.rb`, both talking strictly in domain-specific
terms.

The magic to make this happen is under `lib/memory_repository.rb` and
`lib/active_record_repository.rb`. Tests use the memory repository, whereas
development and production use the active record one.

I checked that tests ran successfully on both storage repositories, but we
should automate this.

## Who's this

This was made by [Josep M. Bach (Txus)](http://txustice.me) under the MIT
license. I'm [@txustice][twitter] on twitter (where you should probably follow
me!).

[twitter]: https://twitter.com/txustice