FactoryBot.define do
  factory :medical_procedure do
    date_complete { "2024-12-23" }
    complete { false }
    date_planned { "2024-12-23" }
    notes { "MyText" }
    animal { nil }
    procedure_type { nil }
  end
end
