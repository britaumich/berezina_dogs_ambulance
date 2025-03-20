class Family
  include ApplicationHelper

  def initialize(animal)
    @animal = animal
  end

  def parent
    @animal.parent
  end

  def add_sibling(sibling_id)
    sibling = Animal.find(sibling_id)
    if @animal.parent_id.present?
      sibling.update(parent_id: @animal.parent_id)
    elsif sibling.parent_id.present?
      # sibling already has a parent, so we need to check if it's the same as @animal's parent
      if sibling.parent_id != @animal.parent_id
        raise "Sibling's parent (#{sibling.parent_id}) is different from @animal's parent (#{@animal.parent_id})"
      end
      # sibling already has the same parent as @animal, so we can just add it to the parent's children
      @animal.update(parent_id: sibling.parent_id)
    else
      # create fake parent and add both animals to it as children
      if @animal.fake_parent_id.present? || Animal.find(sibling_id).fake_parent_id.present?
        fake_parent = @animal.fake_parent_id.present? ? Animal.unscoped.find(@animal.fake_parent_id) : Animal.unscoped.find(Animal.find(sibling_id).fake_parent_id)
      else
        fake_parent = Animal.create!(animal_type_id: @animal.animal_type_id, animal_status_id: @animal.animal_status_id, nickname: 'fake parent', fake_parent: true)
      end
      @animal.update(fake_parent_id: fake_parent.id)
      Animal.find(sibling_id).update(fake_parent_id: fake_parent.id)
    end
  end

  def remove_sibling(sibling_ids)
    sibling_ids.each do |id|
      if @animal.parent_id.present?
        Animal.find(id).update(parent_id: nil)
      else
        Animal.find(id).update(fake_parent_id: nil)
      end
    end
  end

  def update_real_parent(parent_id)
    
    if parent_id.present? && @animal.parent_id.present? && parent_id.to_i == @animal.parent_id
      return
    end
    if parent_id.blank? && @animal.parent_id.blank?
      return
    end
    if parent_id.present? && @animal.parent_id.present? && parent_id.to_i != @animal.parent_id
      # update real parent for siblings
      @animal.siblings.each do |sibling|
        sibling.update(parent_id: parent_id)
      end
      return
    end
    if parent_id.present? && @animal.fake_parent_id.present?
      # remove fake parent and add real parent to animal and siblings (if they exist)
      Animal.unscoped.find(@animal.fake_parent_id).destroy
      @animal.update(fake_parent_id: nil)
      @animal.siblings.each do |sibling|
        sibling.update(fake_parent_id: nil, parent_id: parent_id)
      end
      return
    end
    if parent_id.blank? && @animal.siblings.present?
      # create fake parent and add animal and siblings to it as children
      fake_parent = Animal.create!(animal_type_id: @animal.animal_type_id, animal_status_id: @animal.animal_status_id, nickname: 'fake parent', fake_parent: true)
      @animal.update(fake_parent_id: fake_parent.id)
      @animal.siblings.each do |sibling|
        sibling.update(fake_parent_id: fake_parent.id)
      end
    end
  end

end
