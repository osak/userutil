# -*- coding: utf-8 -*-

Plugin.create(:userutil) do
  def id_names(users)
    users.map{|u| u[:idname]}
  end

  on_followings_created do |service, users|
    @name_list.push(*id_names(users))
  end

  on_followings_destroy do |service, users|
    @name_list -= id_names(users)
  end

  filter_usercomplete do |partial, buf|
    [partial, buf.push(*@name_list.select{|name| name.start_with?(partial)})]
  end

  @name_list = []
  Delayer.new {
    Service.primary.followings(cache: true).next { |users|
      @name_list.push(*id_names(users))
    }
  }
end
