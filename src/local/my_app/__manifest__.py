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
    "depends": ["base"],
    # always loaded
    "data": [
        "security/ir.model.access.csv",
        "views/my_model_view.xml",
        "views/person_view.xml"
        # 'views/templates.xml',
    ],
    # only loaded in demonstration mode
    # 'demo': [
    #     'demo/demo.xml',
    # ],
    "license": "LGPL-3",
}
