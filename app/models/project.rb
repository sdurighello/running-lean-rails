class Project < ApplicationRecord
  belongs_to :created_by, class_name: "User"
  has_many :canvases, dependent: :destroy
  has_many :phases, inverse_of: :project, dependent: :destroy
  has_many :hypotheses, dependent: :destroy
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :phases, allow_destroy: true, reject_if: :all_blank

  # --- Phases

  PHASES = ['Problem/Solution Fit', 'Product/Market Fit', 'Scale']

  def self.get_list_of_phases
    list_of_phases = []
    PHASES.each_with_index do |phase, index|
      list_of_phases << [phase, index]
    end
    list_of_phases
  end

  # --- Status

  def self.status
    %w(Red Amber Green)
  end

  # --- Current phase

  def set_current_phase(phase_id)
    current_phase = Phase.find_by(id: phase_id)
    self.phases.each do |p|
      p.completed = true if p.sequence < current_phase.sequence
      p.completed = false if p.sequence >= current_phase.sequence
    end
    self.current_phase_id = phase_id
    self.save!
  end

  def current_phase
    begin
      Phase.find(self.current_phase_id)
    rescue
      self.errors.add :base, 'Current phase id is not valid'
      return false
    end
  end

  # Project members and creator

  def is_member?(user)
    return true if user.id == self.created_by.id
    self.users.any? { |u| u.id == user.id  }
  end

  def creator
    self.created_by
  end

  def search_users(search_string)
    # Search string must not be empty
    # Users must neither be already members of the project nor the creator.
    # Return only users with name/email matches of the search_string ("email ~* ? OR name ~* ?", "/#{search_string}/g", "/#{search_string}/g")
    if search_string.present?
      User.where.not(id: self.created_by.id)
        .where.not(id: self.users.map { |u| u.id  })
        .where("email like ? OR name like ?", "%#{search_string}%", "%#{search_string}%")
    else
      self.errors.add :base, 'Search string cannot be empty'
      return false
    end
  end

  def add_user(user_id, current_user_id)
    if (current_user_id == self.created_by.id) && (!self.users.any? { |u| u.id == user_id  })
      user = User.find_by(id: user_id)
      if user.present?
        self.users << user
        self.save!
      end
    end
  end

  def remove_user(user_id, current_user_id)
    # Only creators can remove but Users can remove themselves
    if ((current_user_id == self.created_by.id) || (user_id == current_user_id)) && (self.users.any? { |u| u.id == user_id  })
      user = User.find_by(id: user_id)
      if user.present?
        self.users.delete(user) # this doesn't destroy the user object but just the association
        self.save!
      end
    end
  end

  # Active/Inactive project

  def update_active_status(current_user_id)
    if self.created_by.id == current_user_id
      self.active ? self.active = false : self.active = true
      self.save!
    end
  end

  # Start date - End date - Duration (in days)

  def start_date
    earliest_date_phase = (self.phases).min_by { |s| s.start_date} if !self.phases.empty?
    if earliest_date_phase.present?
      earliest_date_phase.start_date
    else
      nil
    end
  end

  def end_date
    latest_date_phase = (self.phases).max_by { |s| s.end_date} if !self.phases.empty?
    if latest_date_phase.present?
      latest_date_phase.end_date
    else
      nil
    end
  end

  def duration
    (self.end_date - self.start_date).to_i if (self.start_date.present? && self.end_date.present?)
  end

  # Experiment completion

  def experiment_completion
    # Ratio of experiments completed across all phases
    if !self.phases.empty?
      number_of_experiments = 0
      experiments_completed = 0
      self.phases.each do |phase|
        if !phase.experiments.empty?
          number_of_experiments += phase.experiments.length
          experiments_completed += phase.experiments.count { |e| e.completed}
        end
      end
      number_of_experiments == 0 ? 0 : experiments_completed / number_of_experiments
    else
      0
    end
  end

  # --- Private methods ---

  private

end
