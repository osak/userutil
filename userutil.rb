# -*- coding: utf-8 -*-

Plugin.create(:userutil) do
  on_followings_created do |service, users|
    @user_list.push(*users)
  end

  on_followings_destroy do |service, users|
    @user_list -= users
  end

  filter_user_prefix_search do |partial, buf|
    [partial, buf.push(*@user_list.select{|user| user[:idname].start_with?(partial)})]
  end

  @user_list = []
  Delayer.new {
    Service.primary.followings(cache: true).next { |users|
      @user_list = users.compact.dup
    }

    Enumerator.new {|y|
      Plugin.filtering(:worlds, y)
    }.select{|world|
      world != Service.primary && world.respond_to?(:followings)
    }.map{|world|
      world.followings(cache: true).next { |users|
        users = users.compact
        @user_list.concat users
      }
    }
  }
end
