{
    "name": "my_app",
    "summary": """Not yet!""",
    "description": """
        Long description of module's purpose
    """,
    "author": "Javohir",
    "website": "http://github.com/javohir-swe",
    "category": "Uncategorized",
    "version": "0.1",
    # any module necessary for this one to work correctly
    "depends": ["base", "mail"],
    # always loaded
    "data": [
        "security/ir.model.access.csv",
        "views/actions.xml",
        "views/menuitems.xml",
        "views/my_model_view.xml",
        "views/person_view.xml",
        "views/fields_view.xml",
        "views/cusom_view.xml",
        "views/widgets_view.xml",
    ],
    # only loaded in demonstration mode
    "demo": [
        "data/demo_data.xml",  # Demo ma'lumotlarni qo'shish
    ],
    "license": "LGPL-3",
    "installable": True,
    "application": True,
    "sequence": -1000,
}
