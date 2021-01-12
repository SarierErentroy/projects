import connection
import purchaser_module


class Group:
    def __init__(self, user_name, group_name, item_name, max_price, category_id, end_time_day, end_time_time, description, id_=-1):
        self.group_name = group_name
        self.item_name = item_name
        self.max_price = int(max_price)
        self.manager = user_name

        self.category_id = category_id
        self.end_date = end_time_day 
        self.end_time = end_time_time + ":00"
        self.description_group = description
        if id != -1:
            self.id_ = id_


def add(group_):
    query = '''INSERT INTO `groups`(group_name, item_name, max_price, category_id, manager, end_date, end_time, description_group) 
    VALUES('{}', '{}', {}, {}, '{}', '{}', '{}', '{}')'''.format(group_.group_name, group_.item_name, group_.max_price,
                                                           group_.category_id, group_.manager, group_.end_date, group_.end_time,
                                                           group_.description)
    connection.do_query_with_change(query)

    group_id = get_id_group(group_)

    purch = purchaser_module.Purchaser(group_.manager, group_id)
    if purchaser_module.add(purch):
        return True
    return False


def get_id_group(group_):
    query = '''SELECT id FROM `groups`
    WHERE group_name = '{}' and manager = '{}'  '''.format(group_.group_name, group_.manager)
    res = connection.do_query(query)
    if res:
        return res[0].get("id", 0)
    return None


def get_all_groups_of_user_name(name):

    groups = []
    all_id_groups = purchaser_module.get_id_group_by_name(name)

    for id_ in all_id_groups:
        query = '''SELECT * FROM `groups`
        WHERE id = {} '''.format(id_)
        res = connection.do_query(query)
        if res:
            groups.append(get_group(res[0]))

    return groups

def get_group(dict_group):
    id_ = dict_group.get("id")
    group_name = dict_group.get("group_name")
    item_name = dict_group.get("item_name")
    max_price = dict_group.get("max_price")
    category_id = dict_group.get("category_id")
    manager = dict_group.get("manager")

    end_date = str(dict_group.get("end_date"))
    end_time = str(dict_group.get("end_time"))#[:len(dict_group.get("end_time"))-3]
    end_time = end_time[:len(end_time) - 3]
    description_group = dict_group.get("description_group")
    
    g = Group(manager, group_name, item_name, max_price, category_id, end_date, end_time,description_group, id_)
    return g


