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
      @user_list = users.dup
    }
  }
end
